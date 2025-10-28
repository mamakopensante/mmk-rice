#!/bin/bash
set -euo pipefail

SONGS_DIR="$HOME/Music/Songs"
CACHE_DIR="$SONGS_DIR/.cache"
PY_SCRIPT="$HOME/.local/bin/get_spotify_playlist.py"
PLAYLISTS_FILE="$SONGS_DIR/playlists.txt"

mkdir -p "$SONGS_DIR" "$CACHE_DIR"

if [ ! -f "$PLAYLISTS_FILE" ]; then
  echo "❌ Arquivo playlists.txt não encontrado em $PLAYLISTS_FILE"
  exit 1
fi

while IFS= read -r url; do
  [ -z "$url" ] && continue

  echo "🎧 Processando: $url"
  OUTPUT=$(python3 "$PY_SCRIPT" "$url")

  # Extrair nome da playlist
  PLAYLIST_NAME=$(echo "$OUTPUT" | grep '^#PLAYLIST_NAME:' | cut -d':' -f2- | tr -d '\n' | sed 's|/| - |g')
  echo "📁 Playlist: $PLAYLIST_NAME"

  PLAYLIST_DIR="$SONGS_DIR/$PLAYLIST_NAME"
  CACHE_FILE="$CACHE_DIR/$PLAYLIST_NAME.txt"

  mkdir -p "$PLAYLIST_DIR"
  touch "$CACHE_FILE"

  echo "$OUTPUT" | grep -v '^#' > /tmp/playlist.txt
  comm -23 <(sort /tmp/playlist.txt) <(sort "$CACHE_FILE") > /tmp/new.txt

  if [ ! -s /tmp/new.txt ]; then
    echo "✅ Nenhuma nova música para '$PLAYLIST_NAME'."
    continue
  fi

  echo "🎵 Baixando novas músicas..."
  while IFS= read -r song; do
    [ -z "$song" ] && continue
    echo "🔽 $song"

    # Obter URL e duração do primeiro resultado
    INFO=$(yt-dlp --get-id --get-duration "ytsearch1:$song" 2>/dev/null || true)
    VIDEO_ID=$(echo "$INFO" | sed -n '1p')
    DURATION=$(echo "$INFO" | sed -n '2p')

    if [ -z "$VIDEO_ID" ] || [ -z "$DURATION" ]; then
      echo "⚠️  Não foi possível obter informações para '$song'. Pulando..."
      continue
    fi

    # Converter duração (ex: 3:12:45 → segundos)
    SECS=$(echo "$DURATION" | awk -F: '{if (NF==3) print $1*3600 + $2*60 + $3; else if (NF==2) print $1*60 + $2; else print $1}')

    # Perguntar se o vídeo é muito longo (>15min)
    if [ "$SECS" -gt 900 ]; then
      echo "⚠️  Vídeo encontrado tem duração de $DURATION — deseja baixar mesmo assim?"
      read -rp "(y/N): " CONFIRM
      if [[ ! "$CONFIRM" =~ ^[yY]$ ]]; then
        echo "⏩ Pulando '$song'"
        continue
      fi
    fi

    # Download confirmado
    yt-dlp -x --audio-format mp3 "https://www.youtube.com/watch?v=$VIDEO_ID" -o "$PLAYLIST_DIR/%(title)s.%(ext)s"
    echo "$song" >> "$CACHE_FILE"

  done < /tmp/new.txt

  echo "🔄 Atualizando MPD..."
  mpc update "$PLAYLIST_DIR"

done < "$PLAYLISTS_FILE"

echo "✅ Sincronização completa!"
