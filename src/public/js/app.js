document.addEventListener('DOMContentLoaded', () => {
    function showFilter(type) {
        const filtersDiv = document.getElementById('filters');
        filtersDiv.innerHTML = ''; // Limpiar cualquier filtro existente

        if (type === 'nombre') {
            filtersDiv.innerHTML = `
                <form id="nombre-form">
                    <div class="form-group">
                        <label for="nombre">Nombre Completo:</label>
                        <input type="text" class="form-control" id="nombre" required>
                    </div>
                    <button type="submit" class="btn btn-primary">Buscar</button>
                </form>
            `;
            document.getElementById('nombre-form').addEventListener('submit', async (event) => {
                event.preventDefault();
                const nombre = document.getElementById('nombre').value;
                await fetchRecibosByNombre(nombre);
            });
        } else if (type === 'fecha') {
            filtersDiv.innerHTML = `
                <form id="fecha-form">
                    <div class="form-group">
                        <label for="fecha-inicio">Fecha Inicio:</label>
                        <input type="date" class="form-control" id="fecha-inicio" required>
                    </div>
                    <div class="form-group">
                        <label for="fecha-fin">Fecha Fin:</label>
                        <input type="date" class="form-control" id="fecha-fin" required>
                    </div>
                    <button type="submit" class="btn btn-primary">Buscar</button>
                </form>
            `;
            document.getElementById('fecha-form').addEventListener('submit', async (event) => {
                event.preventDefault();
                const fechaInicio = document.getElementById('fecha-inicio').value;
                const fechaFin = document.getElementById('fecha-fin').value;
                await fetchRecibosByFecha(fechaInicio, fechaFin);
            });
        }
    }

    async function fetchRecibos() {
        try {
            const response = await fetch('/api/recibos');
            const recibos = await response.json();
            displayRecibos(recibos);
        } catch (error) {
            console.error('Error fetching recibos:', error);
        }
    }

    async function fetchRecibosByNombre(nombre) {
        try {
            const response = await fetch('/api/recibos/nombre', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({ nombre_completo: nombre }),
            });
            const recibos = await response.json();
            displayRecibos(recibos);
        } catch (error) {
            console.error('Error fetching recibos by nombre:', error);
        }
    }

    async function fetchRecibosByFecha(fechaInicio, fechaFin) {
        try {
            const response = await fetch('/api/recibos/fecha', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({ fecha_inicio: fechaInicio, fecha_fin: fechaFin }),
            });
            const recibos = await response.json();
            displayRecibos(recibos);
        } catch (error) {
            console.error('Error fetching recibos by fecha:', error);
        }
    }

    function displayRecibos(recibos) {
        const recibosBody = document.getElementById('recibos-body');
        recibosBody.innerHTML = '';

        recibos.forEach(recibo => {
            const row = document.createElement('tr');
            row.innerHTML = `
                <td>${recibo.fecha_cotizacion}</td>
                <td>${recibo.monto_cotizacion}</td>
                <td>${recibo.fecha_venta}</td>
                <td>${recibo.subtotal}</td>
                <td>${recibo.total_promocion}</td>
                <td>${recibo.extras}</td>
                <td>${recibo.total}</td>
                <td>${recibo.fecha_pago}</td>
                <td>${recibo.cantidad_pagada}</td>
                <td>${recibo.saldo}</td>
            `;
            recibosBody.appendChild(row);
        });
    }

    fetchRecibos();
    window.showFilter = showFilter;
});




