#include <iostream>
#include <fstream>
#include <vector>
#include <string>

using namespace std;

const string FILENAME = "todo.txt";

void showMenu() {
    cout << "\nTo-Do List Manager\n";
    cout << "------------------\n";
    cout << "1. View tasks\n";
    cout << "2. Add task\n";
    cout << "3. Clear all tasks\n";
    cout << "4. Exit\n";
    cout << "Choose an option: ";
}

void viewTasks() {
    ifstream file(FILENAME);
    string task;
    int count = 1;

    cout << "\nYour Tasks:\n";
    cout << "-----------\n";
    while (getline(file, task)) {
        cout << count++ << ". " << task << endl;
    }

    file.close();
    if (count == 1) {
        cout << "No tasks found.\n";
    }
}

void addTask() {
    cin.ignore();
    string task;
    cout << "Enter new task: ";
    getline(cin, task);

    ofstream file(FILENAME, ios::app);
    file << task << endl;
    file.close();

    cout << "Task added!\n";
}

void clearTasks() {
    ofstream file(FILENAME, ios::trunc);
    file.close();
    cout << "All tasks cleared!\n";
}

int main() {
    int choice;

    do {
        showMenu();
        cin >> choice;

        switch (choice) {
            case 1: viewTasks(); break;
            case 2: addTask(); break;
            case 3: clearTasks(); break;
            case 4: cout << "Goodbye!\n"; break;
            default: cout << "Invalid option.\n"; break;
        }
    } while (choice != 4);

    return 0;
}
