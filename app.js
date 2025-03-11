const API_GATEWAY_URL = "https://uij5hsagih.execute-api.us-east-1.amazonaws.com/dev"; 


async function fetchTasks() {
    try {
        const response = await fetch(`${API_GATEWAY_URL}/tasks`);
        if (!response.ok) {
            throw new Error(`HTTP error! Status: ${response.status}`);
        }
        const tasks = await response.json();
        renderTasks(tasks);
    } catch (error) {
        console.error("Error fetching tasks:", error);
        document.getElementById("task-list").innerHTML = `<p style="color: red;">Error fetching tasks</p>`;
    }
}


async function createTask() {
    const taskTitle = document.getElementById("task-title").value;
    if (!taskTitle) {
        alert("Task title cannot be empty!");
        return;
    }

    try {
        const response = await fetch(`${API_GATEWAY_URL}/tasks`, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ title: taskTitle })
        });

        const data = await response.json();
        console.log("Task created:", data);
        document.getElementById("task-title").value = "";  
        fetchTasks();  
    } catch (error) {
        console.error("Error creating task:", error);
    }
}


async function deleteTask(taskId) {
    try {
        const response = await fetch(`${API_GATEWAY_URL}/tasks/${taskId}`, {
            method: "DELETE"
        });

        const data = await response.json();
        console.log("Task deleted:", data);
        fetchTasks();  
    } catch (error) {
        console.error("Error deleting task:", error);
    }
}


function renderTasks(tasks) {
    const taskList = document.getElementById("task-list");
    taskList.innerHTML = ""; 

    if (tasks.length === 0) {
        taskList.innerHTML = "<p>No tasks found.</p>";
        return;
    }

    tasks.forEach(task => {
        const li = document.createElement("li");
        li.innerHTML = `${task.title} (${task.status}) <button onclick="deleteTask('${task.task_id}')">🗑️ Usuń</button>`;
        taskList.appendChild(li);
    });
}


document.addEventListener("DOMContentLoaded", fetchTasks);
