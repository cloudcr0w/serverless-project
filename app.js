const API_GATEWAY_URL = "https://uij5hsagih.execute-api.us-east-1.amazonaws.com/dev";

async function fetchTasks() {
    try {
        const response = await fetch(`${API_GATEWAY_URL}/tasks`);
        const tasks = await response.json();
        document.getElementById("api-response").innerText = JSON.stringify(tasks, null, 2);
    } catch (error) {
        console.error("Error fetching tasks:", error);
        document.getElementById("api-response").innerText = "Error fetching tasks.";
    }
}

async function createTask() {
    try {
        const response = await fetch(`${API_GATEWAY_URL}/tasks`, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ title: "New Task" })
        });

        const data = await response.json();
        console.log("Task created:", data);
        fetchTasks();
    } catch (error) {
        console.error("Error creating task:", error);
    }
}
