// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title SimpleTodo
 * @dev A basic smart contract to manage a personal to-do list.
 * Users can add, complete, delete, and view their own tasks.
 */
contract SimpleTodo {

    /**
     * @dev Defines the structure of a TodoItem.
     * Each item consists of:
     * - task: The description of the task.
     * - completed: A boolean indicating whether the task is completed.
     */
    struct TodoItem {
        string task;
        bool completed;
    }

    /**
     * @dev A mapping to store an array of tasks for each user (Ethereum address).
     * The key is the user's wallet address, and the value is an array of TodoItem structs.
     */
    mapping(address => TodoItem[]) private todos;

    /**
     * @dev Events are used to log important actions on the blockchain.
     * These events can be listened to by external applications (like a frontend).
     */
    event TaskAdded(address indexed user, string task);
    event TaskCompleted(address indexed user, uint index);
    event TaskDeleted(address indexed user, uint index);

    /**
     * @notice Adds a new task to the user's to-do list.
     * @dev The function stores the new task in the mapping under the sender's address.
     * @param _task The description of the task.
     */
    function addTask(string memory _task) public {
        require(bytes(_task).length > 0, "Task cannot be empty"); // Ensures the task is not an empty string.

        todos[msg.sender].push(TodoItem(_task, false)); // Adds the new task with 'completed' set to false.
        emit TaskAdded(msg.sender, _task); // Emits an event to notify that a new task was added.
    }

    /**
     * @notice Marks a task as completed.
     * @dev Updates the 'completed' status of a task at a given index.
     * @param _index The position of the task in the user's to-do list.
     */
    function completeTask(uint _index) public {
        require(_index < todos[msg.sender].length, "Invalid index"); // Ensures the index is within range.

        todos[msg.sender][_index].completed = true; // Marks the task as completed.
        emit TaskCompleted(msg.sender, _index); // Emits an event to indicate the task was completed.
    }

    /**
     * @notice Deletes a task from the user's to-do list.
     * @dev Moves the last task to the deleted position to maintain array integrity, then removes the last task.
     * @param _index The position of the task in the user's to-do list.
     */
    function deleteTask(uint _index) public {
        require(_index < todos[msg.sender].length, "Invalid index"); // Ensures the index is valid.

        uint lastIndex = todos[msg.sender].length - 1; // Get the last task index.

        // Swap the task to be deleted with the last task to avoid shifting elements.
        todos[msg.sender][_index] = todos[msg.sender][lastIndex];

        todos[msg.sender].pop(); // Remove the last task (which is now a duplicate).

        emit TaskDeleted(msg.sender, _index); // Emits an event to indicate the task was deleted.
    }

    /**
     * @notice Retrieves all tasks belonging to the sender.
     * @dev Returns an array of TodoItem structs.
     * @return An array of the user's tasks.
     */
    function getTasks() public view returns (TodoItem[] memory) {
        return todos[msg.sender]; // Returns all tasks associated with the sender.
    }
}
