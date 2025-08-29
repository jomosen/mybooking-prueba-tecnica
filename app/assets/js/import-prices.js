$(document).ready(function () {
    handleFileUpload();
});

function handleFileUpload() {
    $('#csv_file').change(function() {
        const file = this.files[0];
        if (file) {
        const formData = new FormData();
        formData.append('csv_file', file);

        fetch('/api/prices/import/csv', {
            method: 'POST',
            body: formData
        })
        .then(response => {
            if (!response.ok) throw new Error(`HTTP ${response.status}`);
            return response.json();
        })
        .then(data => {
            console.log(data);
            alert(data);
        })
        .catch(error => {
            console.error(error);
            alert(`Error al importar el archivo CSV: ${error.message}`);
        });
        }
    });
    }