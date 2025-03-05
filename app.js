const API_GATEWAY_URL = "https://uij5hsagih.execute-api.us-east-1.amazonaws.com/dev";

async function fetchData() {
    try {
        const response = await fetch(API_GATEWAY_URL);
        const data = await response.json();
        document.getElementById("api-response").innerText = data.message;
    } catch (error) {
        console.error("Error fetching data:", error);
        document.getElementById("api-response").innerText = "Error fetching data.";
    }
}
