document.getElementById('btnExportPdf').addEventListener('click', function() {
    const element = document.getElementById('factureContent');
    const filename = this.dataset.filename || 'facture.pdf';

    const opt = {
        margin: 0.3,
        filename: filename,
        image: { type: 'jpeg', quality: 0.98 },
        html2canvas: { scale: 2 },
        jsPDF: { unit: 'in', format: 'a4', orientation: 'portrait' }
    };

    html2pdf().set(opt).from(element).save();
});
