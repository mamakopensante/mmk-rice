#!/usr/bin/env python3
import spotipy
from spotipy.oauth2 import SpotifyOAuth
import sys

if len(sys.argv) < 2:
    print("Uso: get_spotify_playlist.py <playlist_url>")
    sys.exit(1)

scope = "playlist-read-private"
sp = spotipy.Spotify(auth_manager=SpotifyOAuth(scope=scope))

url = sys.argv[1]
playlist_id = url.split("/")[-1].split("?")[0]  # extrai ID
playlist = sp.playlist(playlist_id)

# Nome da playlist
print(f"#PLAYLIST_NAME:{playlist['name']}")

# Músicas
for item in playlist["tracks"]["items"]:
    track = item["track"]
    if track is None:
        continue
    name = track["name"]
    artist = track["artists"][0]["name"]
    print(f"{name} - {artist}")
