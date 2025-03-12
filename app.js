const API_GATEWAY_URL = "https://uij5hsagih.execute-api.us-east-1.amazonaws.com/dev";

// Fetch the list of tasks when the page loads
document.addEventListener("DOMContentLoaded", fetchTasks);

// Function to fetch tasks from the API
async function fetchTasks() {
    try {
        const response = await fetch(`${API_GATEWAY_URL}/tasks`);
        const tasks = await response.json();
        renderTasks(tasks);
    } catch (error) {
        console.error("Error fetching tasks:", error);
        document.getElementById("task-list").innerHTML = "<li>Error loading tasks</li>";
    }
}

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

// Function to create a new task
async function createTask() {
    const taskTitle = document.getElementById("task-title").value.trim();

    if (taskTitle === "") {
        alert("Task title cannot be empty.");
        return;
    }

    try {
        const response = await fetch(`${API_GATEWAY_URL}/tasks`, {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify({ title: taskTitle })
        });

        if (!response.ok) {
            throw new Error("Failed to create task");
        }

        document.getElementById("task-title").value = ""; // Clear input field
        fetchTasks(); // Refresh the task list
    } catch (error) {
        console.error("Error creating task:", error);
    }
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
