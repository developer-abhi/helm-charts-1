{{- define "cell0_db_path" -}}
mysql+pymysql://{{.Values.cell0dbUser}}:{{ default .Values.cell0dbPassword .Values.global.dbPassword | urlquery }}@{{.Chart.Name}}-mariadb.{{include "svc_fqdn" .}}:3306/{{.Values.cell0dbName}}?charset=utf8
{{- end -}}

{{- define "cell2_db_path" -}}
{{- if eq .Values.cell2.enabled true -}}
mysql+pymysql://{{.Values.cell2dbUser}}:{{ default .Values.cell2dbPassword .Values.global.dbPassword | urlquery }}@{{.Chart.Name}}-{{.Values.cell2.name}}-mariadb.{{include "svc_fqdn" .}}:3306/{{.Values.cell2dbName}}?charset=utf8
{{- end -}}
{{- end -}}

{{- define "cell2_db_path_for_exporter" -}}
{{- if eq .Values.cell2.enabled true -}}
mysql://{{.Values.cell2dbUser}}:{{ default .Values.cell2dbPassword .Values.global.dbPassword | urlquery }}@tcp({{.Chart.Name}}-{{.Values.cell2.name}}-mariadb.{{include "svc_fqdn" .}}:3306)/{{.Values.cell2dbName}}
{{- end -}}
{{- end -}}

{{- define "cell2_transport_url" -}}
rabbit://{{ default "" .Values.global.user_suffix | print .Values.rabbitmq_cell2.users.default.user }}:{{ required "rabbitmq_cell2.users.default.password required" .Values.rabbitmq_cell2.users.default.password | urlquery }}@{{.Chart.Name}}-{{.Values.cell2.name}}-rabbitmq.{{include "svc_fqdn" .}}:{{ .Values.rabbitmq_cell2.port | default 5672 }}{{ .Values.rabbitmq_cell2.virtual_host | default "/" }}
{{- end -}}


{{- define "container_image_nova" -}}
  {{- $name := index . 1 -}}
  {{- with index . 0 -}}
    {{- $version_name := printf "imageVersionNova%s" ($name | lower | replace "-" " " | title | nospace) -}}
    {{- $image_name := ( .Values.loci.nova | ternary .Values.imageNameNova (printf "ubuntu-source-nova-%s" ($name | lower)) ) -}}

    {{ required ".Values.global.registry is missing" .Values.global.registry}}/{{$image_name}}:{{index .Values $version_name | default .Values.imageVersionNova | default .Values.imageVersion | required "Please set nova.imageVersionNova or similar" }}
 
  {{- end -}}
{{- end -}}

{{- define "container_image_openvswitch" -}}
  {{- $name := index . 1 -}}
  {{- with index . 0 -}}
    {{- $version_name := printf "imageVersionOpenvswitch%s" ($name | lower | replace "-" " " | title | nospace) -}}
    {{- $image_name := ( .Values.loci.nova | ternary .Values.imageNameNova (printf "ubuntu-source-openvswitch-%s" ($name | lower)) ) -}}

    {{ required ".Values.global.registry is missing" .Values.global.registry}}/{{$image_name}}:{{index .Values $version_name | default .Values.imageVersionOpenvswitch | default .Values.imageVersionNova | default .Values.imageVersion | required "Please set imageVersionOpenvswitch or similar" }}

  {{- end -}}
{{- end -}}


{{- define "container_image_neutron" -}}
  {{- $name := index . 1 -}}
  {{- with index . 0 -}}
    {{- $version_name := printf "imageVersionNeutron%s" ($name | lower | replace "-" " " | title | nospace) -}}
    {{- $image_name := .Values.imageNameNeutron -}}

    {{ required ".Values.global.registry is missing" .Values.global.registry}}/{{$image_name}}:{{index .Values $version_name | default .Values.imageVersionNeutron | required "Please set imageVersionNeutron or similar" }}

  {{- end -}}
{{- end -}}

