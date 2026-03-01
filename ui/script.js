window.addEventListener('message', function(event) {
    const d = event.data;

    if (d.type === "UPDATE_OVERLAYS") {
        const container = document.getElementById("overlays-container");
        let html = "";
        
        // Iterujeme přes všechny objekty (animal, railing, poop, atd.)
        for (const [cat, state] of Object.entries(d.states)) {
            let imgHtml = "";
            if (state.showImage && state.imagePath) {
                // Přidán onerror pro skrytí prázdného místa pokud obrázek chybí
                imgHtml = `<div class="info-header"><img src="images/${state.imagePath}.png" class="info-image" onerror="this.style.display='none'"></div>`;
            }
            
            let rowsHtml = "";
            if (state.data) {
                state.data.forEach(row => {
                    if (row && row.text) {
                        rowsHtml += `<div class="info-row" style="color: ${row.color || '#ffffff'}">${row.text}</div>`;
                    }
                });
            }
            
            // Každá kategorie má vlastní box
            html += `
            <div class="info-card" id="info-${cat}">
                ${imgHtml}
                <div class="info-content">${rowsHtml}</div>
            </div>`;
        }
        
        container.innerHTML = html;

    } else if (d.type === "OPEN_SHELTER") {
        document.getElementById("shelter-menu").classList.remove("hidden");
        let html = "";
        d.animals.forEach(a => {
            html += `
            <div class="animal-card">
                <img src="images/${a.breed}.png" onerror="this.src='images/default.png'">
                <h3>${a.name}</h3>
                <p>Druh: ${a.breed}</p>
                <p>Věk: ${a.age}</p>
                <button class="buy-btn" onclick='buyAnimal(${a.id}, ${a.price}, ${JSON.stringify(a.coords)})'>Vykoupit za $${a.price}</button>
            </div>`;
        });
        if (d.animals.length === 0) {
            html = "<p style='color: white;'>Útulek je aktuálně prázdný.</p>";
        }
        document.getElementById("shelter-list").innerHTML = html;

    } else if (d.type === "CLOSE_SHELTER") {
        document.getElementById("shelter-menu").classList.add("hidden");
    }
});

function closeShelter() {
    fetch(`https://${GetParentResourceName()}/closeShelter`, {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({})
    });
    document.getElementById("shelter-menu").classList.add("hidden");
}

function buyAnimal(id, price, coords) {
    fetch(`https://${GetParentResourceName()}/buyAnimal`, {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ id: id, price: price, coords: coords })
    });
}