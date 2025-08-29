$(document).ready(function () {
    initializeSelectors();
    initializeDataTable();
    handleSelectChange();
    handleFormSubmit();
});

function loadRateTypes(rental_location_id) {
    endpoint = `/api/rental-locations/${rental_location_id}/rate-types`;
    select_selector = 'select[name="rate_type_id"]';
    return reloadSelector(endpoint, select_selector);
}

function loadSeasonDefinitions(rate_type_id, rental_location_id) {
    endpoint = `/api/rate-types/${rate_type_id}/season-definitions?rental_location_id=${rental_location_id}`;
    select_selector = 'select[name="season_definition_id"]';
    if (rate_type_id && rental_location_id) {
        return reloadSelector(endpoint, select_selector);
    }
    return;
}

function loadSeasons(season_definition_id, rate_type_id, rental_location_id) {
    endpoint = `/api/season-definitions/${season_definition_id}/seasons?rental_location_id=${rental_location_id}&rate_type_id=${rate_type_id}`;
    select_selector = 'select[name="season_id"]';
    resetSelect(select_selector);
    if (season_definition_id && rate_type_id && rental_location_id) {
        return reloadSelector(endpoint, select_selector);
    }
    return;
}

async function reloadSelector(endpoint, select_selector) {
    try {
        const res = await fetch(endpoint);
        if (!res.ok) throw new Error(`Error HTTP ${res.status}`);
        const data = await res.json();

        resetSelect(select_selector);

        if (!Array.isArray(data) || data.length === 0) return;

        fillSelect(select_selector, data);

    } catch (err) {
        console.error(err);
    }
    return;
}

function resetSelect(select_selector) {
    // Mantiene solo la opción con value=""
    $(select_selector + ' option').not('[value=""]').remove();
}

function fillSelect(select_selector, options) {
    const $select = $(select_selector);

    options.forEach(opt => {
        $select.append(
            $('<option>', { value: opt.id, text: opt.name })
        );
    });

    $select.trigger('change');
}

function initializeSelectors() {
    $('select[name="rental_location_id"]').select2({
        theme: 'bootstrap-5'
    });
    $('select[name="rate_type_id"]').select2({
        theme: 'bootstrap-5'
    });
    $('select[name="season_definition_id"]').select2({
        theme: 'bootstrap-5'
    });
    $('select[name="season_id"]').select2({
        theme: 'bootstrap-5'
    });
}

function initializeDataTable() {
    $('#prices_table').dataTable({
        paging: true,
        searching: false,
        info: true
    });
}

function handleSelectChange() {
    $('select[name="rental_location_id"]').change(function () {
        rental_location_id = $(this).val();
        loadRateTypes(rental_location_id);
    });

    $('select[name="rate_type_id"]').change(function () {
        rate_type_id = $(this).val();
        rental_location_id = $('select[name="rental_location_id"]').val()
        loadSeasonDefinitions(rate_type_id, rental_location_id);
    });

    $('select[name="season_definition_id"]').change(function () {
        season_definition_id = $(this).val();
        rate_type_id = $('select[name="rate_type_id"]').val()
        rental_location_id = $('select[name="rental_location_id"]').val()
        loadSeasons(season_definition_id, rate_type_id, rental_location_id);
    });
}

function handleFormSubmit() {
    $('#multiple-product-prices-form').submit(function (e) {
        e.preventDefault();

        if (!isFormValid()) return;

        const filters = getFilters();
        const query_string = getFiltersQueryString(filters);
        submitForm(query_string);
    });
}

function isFormValid() {
    empties = [];
    if (!$('select[name="rental_location_id"]').val()) {
        empties.push('Sucursal');
    }
    if (!$('select[name="rate_type_id"]').val()) {
        empties.push('Tipo de tarifa');
    }
    if ($('select[name="season_definition_id"]').val() && !$('select[name="season_id"]').val()) {
        empties.push('Temporada');
    }
    if (!$('select[name="time_measurement"]').val()) {
        empties.push('Duración');
    }

    if (empties.length) {
        validation_message = 'Por favor, seleccione ';
        switch (empties.length) {
            case 1:
                validation_message += empties[0] + '.';
                break;
            case 2:
                validation_message += empties.join(' y ') + '.';
                break;
            default:
                validation_message += empties.slice(0, -1).join(', ') + ' y ' + empties.slice(-1) + '.';
                break;
        }
        alert(validation_message);
        return false;
    }

    return true;
}

function getFilters() {
    return {
        rental_location_id: $('select[name="rental_location_id"]').val(),
        rate_type_id: $('select[name="rate_type_id"]').val(),
        season_definition_id: $('select[name="season_definition_id"]').val(),
        season_id: $('select[name="season_id"]').val(),
        time_measurement: $('select[name="time_measurement"]').val()
    };
}

function getFiltersQueryString(filters) {
    const search_params = new URLSearchParams();
    Object.entries(filters).forEach(([k, v]) => { if (v) search_params.append(k, v); });
    return search_params.toString();
}

async function submitForm(query_string) {
    try {
        const res = await fetch(`/api/prices?${query_string}`);
        if (!res.ok) throw new Error(`HTTP ${res.status}`);
        const data = await res.json();

        headers = data.headers;
        rows = data.rows;

        console.log(headers);
        console.log(rows);

        if ($.fn.DataTable.isDataTable('#prices_table')) {
            $('#prices_table').DataTable().clear().destroy();
            $('#prices_table').empty(); // importante: limpia thead/tbody antiguos
        }

        // Crear tabla con las nuevas columnas y filas
        $('#prices_table').DataTable({
            data: rows,
            columns: headers.map(h => ({ title: h })),
            paging: true,
            searching: false,
            info: true
        });

    } catch (e) {
        console.error(e);
        alert('Error al cargar precios');
    }
}