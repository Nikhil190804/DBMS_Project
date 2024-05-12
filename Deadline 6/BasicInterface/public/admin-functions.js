document.getElementById("logout").addEventListener("click", function (event) {
  window.location.href = "index.html";
});

document.getElementById("option1").addEventListener("click", function (event) {
  fetch("/admin-option1", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: null,
  })
    .then((response) => {
      if (!response.ok) {
        errorInResponse();
        return null;
      }
      return response.json();
    })
    .then((data) => {
      if (data != null) {
        renderCustomerData(data);
      }
    })
    .catch((error) => {
      errorInResponse();
    });
});

function errorInResponse() {
  alert("DataBase Refused !!!!!");
}

function renderCustomerData(data) {
  var newWindow = window.open("", "_blank");
  newWindow.document.title = "Customer Data";
  var table = newWindow.document.createElement("table");
  table.border = "1";
  var headerRow = newWindow.document.createElement("tr");
  for (var key in data[0]) {
    if (key === "adminID" || key === "password") {
      continue;
    }
    var headerCell = newWindow.document.createElement("th");
    headerCell.textContent = key;
    headerRow.appendChild(headerCell);
  }
  table.appendChild(headerRow);

  data.forEach(function (customer) {
    var row = newWindow.document.createElement("tr");
    for (var key in customer) {
      if (key === "adminID" || key === "password") {
        continue;
      }
      var cell = newWindow.document.createElement("td");
      cell.textContent = customer[key];
      row.appendChild(cell);
    }
    table.appendChild(row);
  });
  newWindow.document.body.appendChild(table);
}

document.getElementById("option2").addEventListener("click", function (event) {
  fetch("/admin-option2", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: null,
  })
    .then((response) => {
      if (!response.ok) {
        errorInResponse();
        return null;
      }
      return response.json();
    })
    .then((data) => {
      if (data != null) {
        renderDeliveryData(data);
      }
    })
    .catch((error) => {
      errorInResponse();
    });
});

function renderDeliveryData(data) {
  var newWindow = window.open("", "_blank");
  newWindow.document.title = "Delivery Agents Data";
  var table = newWindow.document.createElement("table");
  table.border = "1";
  var headerRow = newWindow.document.createElement("tr");
  for (var key in data[0]) {
    if (key === "adminID") {
      continue;
    }
    var headerCell = newWindow.document.createElement("th");
    headerCell.textContent = key;
    headerRow.appendChild(headerCell);
  }
  table.appendChild(headerRow);

  data.forEach(function (customer) {
    var row = newWindow.document.createElement("tr");
    for (var key in customer) {
      if (key === "adminID") {
        continue;
      }
      var cell = newWindow.document.createElement("td");
      cell.textContent = customer[key];
      row.appendChild(cell);
    }
    table.appendChild(row);
  });
  newWindow.document.body.appendChild(table);
}
