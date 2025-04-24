const API_GATEWAY_URL = "https://g0o9oadr06.execute-api.us-east-1.amazonaws.com/dev";

// Fetch the list of tasks when the page loads
document.addEventListener("DOMContentLoaded", fetchTasks);

// Function to display tasks
function renderTasks(tasks) {
    const taskList = document.getElementById("task-list");
    taskList.innerHTML = ""; // Clear the list before adding new elements

    if (tasks.length === 0) {
        taskList.innerHTML = "<li>No tasks available</li>";
        return;
    }

    tasks.forEach(task => {
        const li = document.createElement("li");
        li.id = task.task_id;
        li.classList.add("task");
        li.innerHTML = `
            <span>${task.title}</span>
            <button class="delete-btn" onclick="deleteTask('${task.task_id}')">X</button>
        `;
        taskList.appendChild(li);
    });
}



// Function to delete a task
async function deleteTask(taskId) {
    try {
        const response = await fetch(`${API_GATEWAY_URL}/tasks/${taskId}`, {
            method: "DELETE"
        });

        if (!response.ok) {
            throw new Error("Failed to delete task");
        }

        fetchTasks(); // Refresh the task list after deletion
    } catch (error) {
        console.error("Error deleting task:", error);
    }
}
// Function to show alert messages
function showAlert(message, type) {
    const alertContainer = document.getElementById("alert-container");
    alertContainer.innerHTML = `
        <div class="alert alert-${type} fade-in" role="alert">
            ${message}
        </div>
    `;
    setTimeout(() => alertContainer.innerHTML = "", 3000); // Auto-hide after 3s
}

// Modify createTask function to use alerts
async function createTask() {
    const taskTitle = document.getElementById("task-title").value.trim();

    if (taskTitle === "") {
        showAlert("Task title cannot be empty!", "danger");
        return;
    }

    try {
        const response = await fetch(`${API_GATEWAY_URL}/tasks`, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ title: taskTitle })
        });

        if (!response.ok) throw new Error("Failed to create task");

        document.getElementById("task-title").value = "";
        fetchTasks();
        showAlert("Task added successfully!", "success");
    } catch (error) {
        showAlert("Error creating task!", "danger");
    }
}


//error loading
async function fetchTasks() {
    try {
        const response = await fetch(`${API_GATEWAY_URL}/tasks`);
        const tasks = await response.json();

        if (!Array.isArray(tasks)) {
            throw new Error("API response is not an array");
        }

        renderTasks(tasks);
    } catch (error) {
        console.error("Error fetching tasks:", error);
        document.getElementById("task-list").innerHTML = "<li>Error loading tasks</li>";
    }
}

