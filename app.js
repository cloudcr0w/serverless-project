const API_GATEWAY_URL = "https://g0o9oadr06.execute-api.us-east-1.amazonaws.com/dev";

// Fetch tasks on load
document.addEventListener("DOMContentLoaded", () => {
    const toggleBtn = document.getElementById("darkModeToggle");
    if (toggleBtn) {
        const darkModeEnabled = localStorage.getItem("darkMode") === "enabled";
        document.body.classList.toggle("dark-mode", darkModeEnabled);
        toggleBtn.textContent = darkModeEnabled ? "☀️" : "🌙";
        toggleBtn.addEventListener("click", toggleDarkMode);
    }
    fetchTasks();

    // Set footer year
    document.getElementById("year").textContent = new Date().getFullYear();
});

function toggleDarkMode() {
    const isDark = document.body.classList.toggle("dark-mode");
    document.getElementById("darkModeToggle").textContent = isDark ? "☀️" : "🌙";
    localStorage.setItem("darkMode", isDark ? "enabled" : "disabled");

    const githubLink = document.querySelector("#footer a");
    if (githubLink) githubLink.style.color = isDark ? "#ffc107" : "";
}

async function fetchTasks() {
    try {
        const res = await fetch(`${API_GATEWAY_URL}/tasks`);
        const tasks = await res.json();
        if (!Array.isArray(tasks)) throw new Error("API returned non-array");
        renderTasks(tasks);
    } catch (err) {
        console.error("Fetch error:", err);
        document.getElementById("task-list").innerHTML = "<li>Error loading tasks</li>";
    }
}

function renderTasks(tasks) {
    const taskList = document.getElementById("task-list");
    taskList.innerHTML = "";
    document.getElementById("task-counter").textContent = `Tasks: ${tasks.length}`;

    if (tasks.length === 0) {
        taskList.innerHTML = "<li>No tasks available</li>";
        return;
    }

    tasks.forEach(task => addTaskToDOM(task));
}

function addTaskToDOM(task) {
    const li = document.createElement("li");
    li.id = task.task_id;
    li.className = "task fade-in";
    li.innerHTML = `
        <span>${task.title}</span>
        <button class="btn btn-danger btn-sm rounded-circle shadow-sm" onclick="deleteTask('${task.task_id}')">🗑️</button>
    `;
    document.getElementById("task-list").appendChild(li);
    updateTaskCounter();
}

function updateTaskCounter() {
    const taskCount = document.querySelectorAll("#task-list .task").length;
    document.getElementById("task-counter").textContent = `Tasks: ${taskCount}`;
}

function showAlert(message, type) {
    const alertBox = document.getElementById("alert-container");
    alertBox.innerHTML = `<div class="alert alert-${type} fade-in" role="alert">${message}</div>`;
    setTimeout(() => alertBox.innerHTML = "", 3000);
}

async function createTask() {
    const titleInput = document.getElementById("task-title");
    const title = titleInput.value.trim();
    if (!title) return showAlert("Task title cannot be empty!", "danger");

    try {
        const res = await fetch(`${API_GATEWAY_URL}/tasks`, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ title })
        });
        if (!res.ok) throw new Error("Failed to create");
        titleInput.value = "";
        showAlert("Task added successfully!", "success");
        fetchTasks();
    } catch {
        showAlert("Error creating task!", "danger");
    }
}

async function deleteTask(taskId) {
    const taskEl = document.getElementById(taskId);
    if (taskEl) {
        taskEl.classList.add("fade-out");
        setTimeout(async () => {
            try {
                const res = await fetch(`${API_GATEWAY_URL}/tasks/${taskId}`, { method: "DELETE" });
                if (!res.ok) throw new Error();
                fetchTasks();
            } catch {
                showAlert("Error deleting task!", "danger");
            }
        }, 300);
    }
}
