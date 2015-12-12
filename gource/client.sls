{%- from "gource/map.jinja" import client with context %}
{%- if client.enabled %}

gource-packages:
  pkg.installed:
  - names: {{ client.pkgs }}

{%- for video_name, video in client.video.items() %}

gource_{{ video_name }}_dirs:
  file.directory:
    - names:
      - {{ client.dir.workspace }}/{{ video_name }}/sources
      - {{ client.dir.workspace }}/{{ video_name }}/video
    - makedirs: true

{%- for source_name, source in video.source.items() %}

gource_{{ video_name }}_{{ source_name }}_source:
  git.latest:
  - name: {{ source.address }}
  - target: {{ client.dir.workspace }}/{{ video_name }}/sources/{{ source_name }}
  - rev: {{ source.get('revision', 'master') }}

gource_{{ video_name }}_{{ source_name }}_generate_log:
  cmd.run:
    - name: gource --output-custom-log log.txt ./
    - cwd: {{ client.dir.workspace }}/{{ video_name }}/sources/{{ source_name }}
    - require:
      - file: gource_{{ video_name }}_dirs
      - git: gource_{{ video_name }}_{{ source_name }}_source

#gource_{{ video_name }}_{{ source_name }}_append_log:
#  cmd.run:
#    - name: cat {{ client.dir.workspace }}/{{ video_name }}/sources/{{ source_name }}/log.txt >> {{ client.dir.workspace }}/{{ video_name }}/log.txt
#    - require:
#      - cmd: gource_{{ video_name }}_{{ source_name }}_generate_log

# file append check line by line for duplicity which makes this call terrible slow in second run
gource_{{ video_name }}_{{ source_name }}_append_log:
  file.append:
  - name: {{ client.dir.workspace }}/{{ video_name }}/log.txt
  - source: {{ client.dir.workspace }}/{{ video_name }}/sources/{{ source_name }}/log.txt
  - require:
    - cmd: gource_{{ video_name }}_{{ source_name }}_generate_log

{%- endfor %}

gource_{{ video_name }}_stream:
  cmd.run:
    - unless: test -e {{ client.dir.workspace }}/{{ video_name }}/video/stream
    - name: gource --fullscreen --disable-progress -r 60 -s 0.25 --stop-at-end --user-scale 2 --highlight-all-users {{ client.dir.workspace }}/{{ video_name }}/log.txt -o {{ client.dir.workspace }}/{{ video_name }}/video/stream
    - require:
      - pkg: gource-packages

convert_{{ video_name }}:
  cmd.run:
    - unless: test -e {{ client.dir.workspace }}/{{ video_name }}/video/video.mp4
    - name: ffmpeg -y -f image2pipe -vcodec ppm -i {{ client.dir.workspace }}/{{ video_name }}/video/stream -vcodec libx264 -b:3000K -r:60 {{ client.dir.workspace }}/{{ video_name }}/video/video.mp4
    - require:
      - cmd: gource_{{ video_name }}_stream

{%- endfor %}

{%- endif %}

