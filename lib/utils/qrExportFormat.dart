enum QrExportFormat {
  png('PNG', 'image/png', '.png'),
  pdf('PDF', 'application/pdf', '.pdf');

  const QrExportFormat(this.displayName, this.mimeType, this.extension);
  final String displayName;
  final String mimeType;
  final String extension;
}