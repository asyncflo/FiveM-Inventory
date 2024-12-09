window.addEventListener("message", (event) => {
    if (event.data.type === "openInventory") {
        document.getElementById("inventory-container").style.display = "block";
        const inventoryList = document.getElementById("inventory-list");
        inventoryList.innerHTML = "";

        event.data.items.forEach((item, index) => {
            const li = document.createElement("li");
            li.textContent = item;
            inventoryList.appendChild(li);
        });
    }
});

document.getElementById("add-item").addEventListener("click", () => {
    fetch("https://resource_name/addItem", {
        method: "POST",
        headers: {
            "Content-Type": "application/json",
        },
        body: JSON.stringify({ itemName: `Item${Math.random()}` }),
    }).then(() => {
        console.log("Item hinzugefügt.");
    });
});

document.getElementById("close-inventory").addEventListener("click", () => {
    document.getElementById("inventory-container").style.display = "none";
    fetch("https://resource_name/closeInventory", { method: "POST" });
});
