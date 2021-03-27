{{/*
Common labels
*/}}
{{- define "common_labels" -}}
app.kubernetes.io/part-of: {{ .Chart.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: "Helm"
{{- end -}}


