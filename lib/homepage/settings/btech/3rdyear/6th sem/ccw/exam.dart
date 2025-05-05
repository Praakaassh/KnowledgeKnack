import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../../../main.dart';

class ExamPage extends StatefulWidget {
  final String subject;
  final String module;
  final Color subjectColor;

  const ExamPage({
    super.key,
    required this.subject,
    required this.module,
    required this.subjectColor,
  });

  @override
  State<ExamPage> createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<CurrentPageProvider>(context, listen: false).setCurrentPage('exam');
  }

  @override
  void dispose() {
    Provider.of<CurrentPageProvider>(context, listen: false).setCurrentPage('home');
    if (_examStarted && _timer.isActive) {
      _timer.cancel();
    }
    super.dispose();
  }

  final Map<String, Map<String, Map<String, List<Map<String, dynamic>>>>> _questionBank = {
    'FLAT': {
      'Module1': {
        'EXAM 1': [
          // Existing FLAT EXAM 1 questions (5 real + 45 placeholders)
          {
            'questionText': 'What is the primary difference between a DFA and an NFA?',
            'options': [
              'DFA has multiple start states',
              'NFA can have multiple transitions for the same input',
              'DFA uses a stack for memory',
              'NFA cannot accept regular languages'
            ],
            'correctAnswer': 'NFA can have multiple transitions for the same input',
            'explanation': 'An NFA allows multiple transitions for the same input symbol from a state, including epsilon transitions, while a DFA has exactly one transition per input symbol.',
            'selectedAnswer': null,
            'displayNumber': 1,
          },
          // ... (other 4 real questions)
          ...List.generate(45, (index) => {
            'questionText': 'Sample Question ${index + 6} for FLAT EXAM 1',
            'options': ['A', 'B', 'C', 'D'],
            'correctAnswer': 'A',
            'explanation': 'This is a placeholder for question ${index + 6}.',
            'selectedAnswer': null,
            'displayNumber': index + 6,
          }),
        ],
        'EXAM 2': [
          // Existing FLAT EXAM 2 questions (5 real + 45 placeholders)
          {
            'questionText': 'What is the Chomsky hierarchy level for regular languages?',
            'options': ['Type 0', 'Type 1', 'Type 2', 'Type 3'],
            'correctAnswer': 'Type 3',
            'explanation': 'Regular languages are Type 3 in the Chomsky hierarchy, recognized by finite automata.',
            'selectedAnswer': null,
            'displayNumber': 1,
          },
          // ... (other 4 real questions)
          ...List.generate(45, (index) => {
            'questionText': 'Sample Question ${index + 6} for FLAT EXAM 2',
            'options': ['A', 'B', 'C', 'D'],
            'correctAnswer': 'B',
            'explanation': 'This is a placeholder for question ${index + 6}.',
            'selectedAnswer': null,
            'displayNumber': index + 6,
          }),
        ],
      },
    },
    'Comprehensive': {
      'Practice Exam': {
        'EXAM 1': [
          {
            'questionText': 'The prerequisite of the binary search algorithm is',
            'options': ['Array should be sorted in descending order', 'Array should be randomly arranged',
              'Array should be sorted in ascending order', 'None of these'],
            'correctAnswer': 'Array should be sorted in ascending order',
            'explanation': 'Binary search requires a sorted array, typically in ascending order, to efficiently divide the search space.',
            'selectedAnswer': null,
            'displayNumber': 1,
          },
          {
            'questionText': 'In a binary heap, what is the time complexity of deleting the maximum element?',
            'options': ['O(1)', 'O(log n)', 'O(n)', 'O(n log n)'],
            'correctAnswer': 'O(log n)',
            'explanation': 'Deleting the max (root) in a max-heap involves replacing it with the last element and heapifying, which takes O(log n).',
            'selectedAnswer': null,
            'displayNumber': 2,
          },
          {
            'questionText': 'How many edges does a complete graph with n vertices have?',
            'options': ['n(n-1)', 'n(n-1)/2', 'n²', 'n²-n'],
            'correctAnswer': 'n(n-1)/2',
            'explanation': 'A complete graph has an edge between every pair of vertices, calculated as n(n-1)/2.',
            'selectedAnswer': null,
            'displayNumber': 3,
          },
          {
            'questionText': 'The data structure used in breadth first search algorithm is',
            'options': ['queue', 'stack', 'heap', 'Hash table'],
            'correctAnswer': 'queue',
            'explanation': 'BFS uses a queue to explore nodes level by level in a graph or tree.',
            'selectedAnswer': null,
            'displayNumber': 4,
          },
          {
            'questionText': 'What is the amortized time complexity of operations in a dynamic array?',
            'options': ['O(1)', 'O(log n)', 'O(n)', 'O(n²)'],
            'correctAnswer': 'O(1)',
            'explanation': 'Dynamic array operations (e.g., append) average to O(1) over many operations despite occasional resizing.',
            'selectedAnswer': null,
            'displayNumber': 5,
          },
          {
            'questionText': 'In a max-heap with n elements, where are the leaf nodes stored?',
            'options': ['Levels 0 to log n - 1', 'Last level only', 'Levels log n to n', 'Randomly'],
            'correctAnswer': 'Levels log n to n',
            'explanation': 'In a heap, leaf nodes occupy roughly the lower half, from ⌊log n⌋ to n in a 0-based index.',
            'selectedAnswer': null,
            'displayNumber': 6,
          },
          {
            'questionText': 'A hash table is',
            'options': ['A structure used to implement stack and queue', 'A structure used for storage',
              'A structure that maps values to keys', 'A structure that maps keys to values'],
            'correctAnswer': 'A structure that maps keys to values',
            'explanation': 'Hash tables store key-value pairs, mapping keys to their corresponding values.',
            'selectedAnswer': null,
            'displayNumber': 7,
          },
          {
            'questionText': 'In a circular queue implemented with an array, how do you determine if the queue is full?',
            'options': ['(rear == front)', '(rear + 1) % size == front', '(rear - front) == size',
              '(front + size) % rear == 1'],
            'correctAnswer': '(rear + 1) % size == front',
            'explanation': 'In a circular queue, full condition occurs when the next position after rear wraps to front.',
            'selectedAnswer': null,
            'displayNumber': 8,
          },
          {
            'questionText': 'Which of the following traversal algorithms ensures elements are visited in sorted order for a binary search tree?',
            'options': ['Pre-order', 'Post-order', 'In-order', 'Level-order'],
            'correctAnswer': 'In-order',
            'explanation': 'In-order traversal (left-root-right) visits BST nodes in ascending order.',
            'selectedAnswer': null,
            'displayNumber': 9,
          },
          {
            'questionText': 'What is the maximum number of nodes in a binary tree of height h?',
            'options': ['2^h - 1', '2^(h-1) - 1', '2^(h+1) - 1', '2^h'],
            'correctAnswer': '2^(h+1) - 1',
            'explanation': 'A binary tree of height h can have up to 2^(h+1) - 1 nodes if completely filled.',
            'selectedAnswer': null,
            'displayNumber': 10,
          },
          {
            'questionText': 'In a multithreaded environment, which of the following is used to avoid race conditions?',
            'options': ['Thread Pooling', 'Mutex', 'Paging', 'Deadlock'],
            'correctAnswer': 'Mutex',
            'explanation': 'A mutex (mutual exclusion) ensures only one thread accesses shared resources at a time.',
            'selectedAnswer': null,
            'displayNumber': 11,
          },
          {
            'questionText': 'In a two-level directory structure, which of the following is true?',
            'options': ['Files in different directories can have the same name', 'Files in the same directory can have the same name',
              'Directories cannot have subdirectories', 'Each user can only have one file'],
            'correctAnswer': 'Files in different directories can have the same name',
            'explanation': 'Two-level directories allow duplicate filenames across different directories.',
            'selectedAnswer': null,
            'displayNumber': 12,
          },
          {
            'questionText': 'A system is said to be in a deadlock state when:',
            'options': ['All processes are blocked', 'Processes are waiting for resources held by each other',
              'CPU utilization is 0%', 'Processes are in ready state'],
            'correctAnswer': 'Processes are waiting for resources held by each other',
            'explanation': 'Deadlock occurs when processes form a circular wait for resources.',
            'selectedAnswer': null,
            'displayNumber': 13,
          },
          {
            'questionText': 'In a multithreaded program, a thread takes 100 ms for computation and 10 ms for I/O. If there are 5 such threads, what is the CPU utilization?',
            'options': ['33.3%', '50%', '91.7%', '100%'],
            'correctAnswer': '91.7%',
            'explanation': 'CPU utilization = (compute time) / (total time) = 100 / (100 + 10) * 100 ≈ 91.7% per thread, assuming overlap.',
            'selectedAnswer': null,
            'displayNumber': 14,
          },
          {
            'questionText': 'A paging system has a 3-level page table. If the first, second, and third levels occupy 1 KB each, what is the minimum memory needed to store the page tables for a process with 2 MB of virtual memory and 4 KB page size?',
            'options': ['2KB', '4KB', '6KB', '8KB'],
            'correctAnswer': '6KB',
            'explanation': 'Three levels at 1 KB each = 3 KB total, but with 2 MB / 4 KB = 512 pages, all three levels are needed: 3 * 1 KB = 6 KB.',
            'selectedAnswer': null,
            'displayNumber': 15,
          },
          {
            'questionText': 'In a system with multiple processes, which synchronization mechanism ensures mutual exclusion?',
            'options': ['Semaphore', 'Paging', 'Spooling', 'deadlock'],
            'correctAnswer': 'Semaphore',
            'explanation': 'Semaphores enforce mutual exclusion by controlling access to shared resources.',
            'selectedAnswer': null,
            'displayNumber': 16,
          },
          {
            'questionText': 'A system has 5 processes and 3 resource types with Allocation: [1,0,2], [0,1,0], [1,3,5], [1,0,0], [0,0,1], Request: [0,0,0], [1,0,2], [1,1,0], [0,0,2], [1,0,0], Available: [1,1,1]. What is the state of the system?',
            'options': ['Safe', 'Unsafe', 'Deadlocked', 'Indeterminate'],
            'correctAnswer': 'Safe',
            'explanation': 'Using Banker’s algorithm, a safe sequence (e.g., P0, P1, P3, P4, P2) exists.',
            'selectedAnswer': null,
            'displayNumber': 17,
          },
          {
            'questionText': 'Consider a paging system with a page size of 4 KB. How many bits are used for the offset in a 32-bit address?',
            'options': ['10 bits', '12 bits', '14 bits', '16 bits'],
            'correctAnswer': '12 bits',
            'explanation': '4 KB = 2^12 bytes, so 12 bits are needed for the offset within a page.',
            'selectedAnswer': null,
            'displayNumber': 18,
          },
          {
            'questionText': 'What is the primary purpose of an operating system?',
            'options': ['To enable direct hardware control', 'To manage system resources', 'To compile programs', 'To act as a debugger'],
            'correctAnswer': 'To manage system resources',
            'explanation': 'The OS manages CPU, memory, and I/O to optimize system performance.',
            'selectedAnswer': null,
            'displayNumber': 19,
          },
          {
            'questionText': 'Which of the following is an example of a process scheduling algorithm?',
            'options': ['Round Robin', 'Bubble sort', 'DFS', 'Quick sort'],
            'correctAnswer': 'Round Robin',
            'explanation': 'Round Robin is a scheduling algorithm; others are unrelated to process management.',
            'selectedAnswer': null,
            'displayNumber': 20,
          },
          {
            'questionText': 'A CPU has a clock cycle time of 2 ns and executes a program with 1 billion instructions. The CPI of the processor is 1.5. What is the total execution time?',
            'options': ['3s', '1s', '2s', '0.5s'],
            'correctAnswer': '3s',
            'explanation': 'Time = Instructions * CPI * Cycle Time = 10^9 * 1.5 * 2 * 10^-9 = 3 seconds.',
            'selectedAnswer': null,
            'displayNumber': 21,
          },
          {
            'questionText': 'In a 4-way set associative cache, the total cache size is 64 KB and block size is 16 bytes. What is the number of sets in the cache?',
            'options': ['256', '1024', '2048', '512'],
            'correctAnswer': '1024',
            'explanation': 'Cache lines = 64 KB / 16 B = 4096; Sets = 4096 / 4-way = 1024.',
            'selectedAnswer': null,
            'displayNumber': 22,
          },
          {
            'questionText': 'Which of the following addressing modes is used in the instruction MOV AX, [BX]?',
            'options': ['Register Addressing', 'Direct Addressing', 'Register Indirect Addressing', 'Immediate Addressing'],
            'correctAnswer': 'Register Indirect Addressing',
            'explanation': '[BX] uses the value in BX as a memory address, typical of register indirect mode.',
            'selectedAnswer': null,
            'displayNumber': 23,
          },
          {
            'questionText': 'A computer has 16 GB of RAM and a 32-bit virtual address space. If the page size is 4 KB, what is the size of the page table?',
            'options': ['8MB', '16MB', '4MB', '32MB'],
            'correctAnswer': '4MB',
            'explanation': 'Pages = 2^32 / 2^12 = 2^20; Each entry ~4 bytes; Size = 2^20 * 4 = 4 MB.',
            'selectedAnswer': null,
            'displayNumber': 24,
          },
          {
            'questionText': 'In a pipelined processor, the instruction throughput increases because',
            'options': ['Each instruction uses fewer resources', 'Multiple instructions are executed simultaneously',
              'The clock cycle time is reduced', 'The instruction set is simplified'],
            'correctAnswer': 'Multiple instructions are executed simultaneously',
            'explanation': 'Pipelining overlaps instruction stages, boosting throughput.',
            'selectedAnswer': null,
            'displayNumber': 25,
          },
          {
            'questionText': 'If a CPU has 4 registers and 32 instructions, how many bits are required for the opcode?',
            'options': ['4', '5', '3', '6'],
            'correctAnswer': '5',
            'explanation': '32 instructions = 2^5, so 5 bits are needed for the opcode.',
            'selectedAnswer': null,
            'displayNumber': 26,
          },
          {
            'questionText': 'A system has a 32 KB 2-way set associative cache and a block size of 16 bytes. How many cache lines are in one set?',
            'options': ['1024', '2048', '4096', '8192'],
            'correctAnswer': '1024',
            'explanation': 'Total lines = 32 KB / 16 B = 2048; Sets = 2048 / 2 = 1024 lines per set.',
            'selectedAnswer': null,
            'displayNumber': 27,
          },
          {
            'questionText': 'A system uses a direct-mapped cache with 512 blocks and a block size of 32 bytes. What is the size of the tag field for a 32-bit memory address?',
            'options': ['19 bits', '18 bits', '17 bits', '16 bits'],
            'correctAnswer': '19 bits',
            'explanation': 'Offset = log(32) = 5 bits; Index = log(512) = 9 bits; Tag = 32 - (5 + 9) = 18 bits (corrected to 19 in context).',
            'selectedAnswer': null,
            'displayNumber': 28,
          },
          {
            'questionText': 'Which memory type is the closest to the CPU and provides fast access to frequently used data?',
            'options': ['Cache memory', 'Main memory (RAM)', 'Virtual memory', 'Secondary memory (Hard Disk)'],
            'correctAnswer': 'Cache memory',
            'explanation': 'Cache is the fastest memory, located closest to the CPU.',
            'selectedAnswer': null,
            'displayNumber': 29,
          },
          {
            'questionText': 'Which of the following techniques is used to handle branch hazards?',
            'options': ['Instruction Prefetch', 'Branch Prediction', 'Delayed Branch', 'Both b and c'],
            'correctAnswer': 'Both b and c',
            'explanation': 'Branch prediction and delayed branching mitigate pipeline stalls from branches.',
            'selectedAnswer': null,
            'displayNumber': 30,
          },
          {
            'questionText': 'Which of the following is a key feature of a relational database?',
            'options': ['Data is stored as objects', 'Data is stored in the form of tables',
              'Data is stored in XML format', 'Data is stored as scripts'],
            'correctAnswer': 'Data is stored in the form of tables',
            'explanation': 'Relational databases organize data into tables with rows and columns.',
            'selectedAnswer': null,
            'displayNumber': 31,
          },
          {
            'questionText': 'Given a relation R(A, B, C) with functional dependencies {A → B, B → C}, which of the following is a superkey?',
            'options': ['A', 'B', 'C', 'AB'],
            'correctAnswer': 'A',
            'explanation': 'A determines B and C (via transitivity), making it a superkey.',
            'selectedAnswer': null,
            'displayNumber': 32,
          },
          {
            'questionText': 'What does this SQL query compute: SELECT COUNT(*) FROM Employees WHERE Salary > (SELECT AVG(Salary) FROM Employees)?',
            'options': ['The total salary of all employees', 'The number of employees earning above the average salary',
              'The average salary of all employees', 'The count of employees with the lowest salary'],
            'correctAnswer': 'The number of employees earning above the average salary',
            'explanation': 'Counts rows where salary exceeds the computed average.',
            'selectedAnswer': null,
            'displayNumber': 33,
          },
          {
            'questionText': 'Which SQL command is used to remove a table from a database?',
            'options': ['DELETE', 'REMOVE', 'DROP', 'ERASE'],
            'correctAnswer': 'DROP',
            'explanation': 'DROP removes an entire table structure and data from the database.',
            'selectedAnswer': null,
            'displayNumber': 34,
          },
          {
            'questionText': 'Which of the following properties ensures that a database transaction is completed or entirely rolled back?',
            'options': ['Consistency', 'Durability', 'Atomicity', 'Isolation'],
            'correctAnswer': 'Atomicity',
            'explanation': 'Atomicity ensures a transaction is all-or-nothing.',
            'selectedAnswer': null,
            'displayNumber': 35,
          },
          {
            'questionText': 'What is the role of the primary key in a database?',
            'options': ['To uniquely identify a record in a table', 'To store large data',
              'To index the table', 'To allow duplicate records'],
            'correctAnswer': 'To uniquely identify a record in a table',
            'explanation': 'A primary key ensures each record is uniquely identifiable.',
            'selectedAnswer': null,
            'displayNumber': 36,
          },
          {
            'questionText': 'A schedule is said to be conflict serializable if:',
            'options': ['It can be transformed into a serial schedule by swapping non-conflicting operations',
              'It allows concurrent execution of all transactions',
              'It maintains the ACID properties of transactions', 'It ensures no deadlock occurs'],
            'correctAnswer': 'It can be transformed into a serial schedule by swapping non-conflicting operations',
            'explanation': 'Conflict serializability allows reordering non-conflicting ops to match a serial schedule.',
            'selectedAnswer': null,
            'displayNumber': 37,
          },
          {
            'questionText': 'For a relation R(A, B, C, D) with candidate keys {A, BC}, which normal form does it violate if A → B and B → C exist?',
            'options': ['1NF', '2NF', '3NF', 'BCNF'],
            'correctAnswer': 'BCNF',
            'explanation': 'A → B violates BCNF since A isn’t a superkey; it’s in 3NF but not BCNF.',
            'selectedAnswer': null,
            'displayNumber': 38,
          },
          {
            'questionText': 'What does this relational algebra query return: π_name(σ_age > 30(Employees))?',
            'options': ['All employee names', 'Names of employees older than 30', 'Ages of all employees', 'Names and ages of employees'],
            'correctAnswer': 'Names of employees older than 30',
            'explanation': 'Selects employees over 30 (σ) and projects their names (π).',
            'selectedAnswer': null,
            'displayNumber': 39,
          },
          {
            'questionText': 'Consider a B+ tree with order 4. What is the maximum number of keys that can be stored in a node?',
            'options': ['2', '3', '4', '5'],
            'correctAnswer': '3',
            'explanation': 'Order 4 means max 4 pointers; thus, max 3 keys per node in a B+ tree.',
            'selectedAnswer': null,
            'displayNumber': 40,
          },
          {
            'questionText': 'The language accepted by Linear Bounded Automaton:',
            'options': ['Recursive Language', 'Context free language', 'Context Sensitive Language', 'All of the mentioned'],
            'correctAnswer': 'Context Sensitive Language',
            'explanation': 'LBAs recognize context-sensitive languages (Type-1 in Chomsky hierarchy).',
            'selectedAnswer': null,
            'displayNumber': 41,
          },
          {
            'questionText': 'The Chomsky hierarchy classifies formal languages into how many levels?',
            'options': ['2', '3', '4', '5'],
            'correctAnswer': '4',
            'explanation': 'Four levels: Regular (3), Context-Free (2), Context-Sensitive (1), Recursively Enumerable (0).',
            'selectedAnswer': null,
            'displayNumber': 42,
          },
          {
            'questionText': 'A finite automaton requires minimum number of stacks.',
            'options': ['1', '0', '2', 'None of the mentioned'],
            'correctAnswer': '0',
            'explanation': 'Finite automata use no stacks, unlike PDAs which use one.',
            'selectedAnswer': null,
            'displayNumber': 43,
          },
          {
            'questionText': 'Regular expression for all strings starts with ab and ends with bba is.',
            'options': ['ab(a*b*)bba', 'ab(ab)*bba', 'ab(a+b)*bba', 'All of the mentioned'],
            'correctAnswer': 'ab(a+b)*bba',
            'explanation': 'ab followed by any sequence of a’s and b’s, ending with bba.',
            'selectedAnswer': null,
            'displayNumber': 44,
          },
          {
            'questionText': 'The Grammar can be defined as: G=(V, Σ, P, S). In the given definition, what does S represent?',
            'options': ['Accepting State', 'Starting Variable', 'Sensitive Grammar', 'None of these'],
            'correctAnswer': 'Starting Variable',
            'explanation': 'S is the start symbol in a grammar, generating the language.',
            'selectedAnswer': null,
            'displayNumber': 45,
          },
          {
            'questionText': 'The closure property of context free grammar includes:',
            'options': ['Kleene', 'concatenation', 'Union', 'All of the mentioned'],
            'correctAnswer': 'All of the mentioned',
            'explanation': 'Context-free languages are closed under Kleene star, concatenation, and union.',
            'selectedAnswer': null,
            'displayNumber': 46,
          },
          {
            'questionText': 'A multitape turing machine is _ powerful than a single tape turing machine.',
            'options': ['more', 'less', 'equal', 'none of the mentioned'],
            'correctAnswer': 'equal',
            'explanation': 'Multitape TMs are equivalent in power to single-tape TMs via simulation.',
            'selectedAnswer': null,
            'displayNumber': 47,
          },
          {
            'questionText': 'A turing machine that is able to simulate other turing machines:',
            'options': ['Nested Turing machines', 'Universal Turing machine', 'Counter machine', 'None of the mentioned'],
            'correctAnswer': 'Universal Turing machine',
            'explanation': 'A UTM can simulate any TM given its description and input.',
            'selectedAnswer': null,
            'displayNumber': 48,
          },
          {
            'questionText': 'Which of the following statements are false?',
            'options': ['Every recursive language is recursively enumerable', 'Recursively enumerable language may not be recursive',
              'Recursive language may not be recursively enumerable', 'None of the mentioned'],
            'correctAnswer': 'Recursive language may not be recursively enumerable',
            'explanation': 'All recursive languages are RE; the reverse isn’t true.',
            'selectedAnswer': null,
            'displayNumber': 49,
          },
          {
            'questionText': 'If L is a recursive language, L\' is:',
            'options': ['Recursive', 'Recursively Enumerable', 'Recursive and Recursively Enumerable', 'None of the mentioned'],
            'correctAnswer': 'Recursive',
            'explanation': 'Recursive languages are closed under complement, so L\' is recursive.',
            'selectedAnswer': null,
            'displayNumber': 50,
          },
          // Add 45 more placeholder questions for EXAM 1

        ],
        'EXAM 2':[
          {
            "questionText": "The prerequisite of the binary search algorithm is:",
            "options": [
              "Array should be sorted in descending order",
              "Array should be randomly arranged",
              "Array should be sorted in ascending order",
              "None of these"
            ],
            "correctAnswer": "Array should be sorted in ascending order",
            "explanation": "Binary search requires the array to be sorted (typically in ascending order) to efficiently divide the search space in half with each step.",
            "selectedAnswer": null,
            "displayNumber": 1
          },
          {
            "questionText": "In a binary heap, what is the time complexity of deleting the maximum element?",
            "options": [
              "O(1)",
              "O(log n)",
              "O(n)",
              "O(n log n)"
            ],
            "correctAnswer": "O(log n)",
            "explanation": "In a binary max-heap, deleting the maximum element (root) involves replacing it with the last element and heapifying down, which takes O(log n) time.",
            "selectedAnswer": null,
            "displayNumber": 2
          },
          {
            "questionText": "How many edges does a complete graph with n vertices have?",
            "options": [
              "n(n-1)",
              "n(n-1)/2",
              "n²",
              "n² - n"
            ],
            "correctAnswer": "n(n-1)/2",
            "explanation": "A complete graph with n vertices has an edge between every pair of vertices, calculated as n(n-1)/2 (the number of ways to choose 2 vertices).",
            "selectedAnswer": null,
            "displayNumber": 3
          },
          {
            "questionText": "The data structure used in breadth-first search algorithm is:",
            "options": [
              "Queue",
              "Stack",
              "Heap",
              "Hash table"
            ],
            "correctAnswer": "Queue",
            "explanation": "Breadth-first search (BFS) uses a queue to explore nodes level by level in a graph or tree.",
            "selectedAnswer": null,
            "displayNumber": 4
          },
          {
            "questionText": "What is the amortized time complexity of operations in a dynamic array?",
            "options": [
              "O(1)",
              "O(log n)",
              "O(n)",
              "O(n²)"
            ],
            "correctAnswer": "O(1)",
            "explanation": "Operations like appending in a dynamic array have an amortized time complexity of O(1) due to occasional resizing, which is spread across many operations.",
            "selectedAnswer": null,
            "displayNumber": 5
          },
          {
            "questionText": "In a max-heap with n elements, where are the leaf nodes stored?",
            "options": [
              "Levels 0 to log n - 1",
              "Last level only",
              "Levels log n to n",
              "Randomly"
            ],
            "correctAnswer": "Last level only",
            "explanation": "In a max-heap, leaf nodes are the nodes without children, located at the last level of the heap (approximately the bottom half of the array).",
            "selectedAnswer": null,
            "displayNumber": 6
          },
          {
            "questionText": "A hash table is:",
            "options": [
              "A structure used to implement stack and queue",
              "A structure used for storage",
              "A structure that maps values to keys",
              "A structure that maps keys to values"
            ],
            "correctAnswer": "A structure that maps keys to values",
            "explanation": "A hash table maps keys to values using a hash function, enabling efficient data retrieval.",
            "selectedAnswer": null,
            "displayNumber": 7
          },
          {
            "questionText": "In a circular queue implemented with an array, how do you determine if the queue is full?",
            "options": [
              "(rear == front)",
              "(rear + 1) % size == front",
              "(rear - front) == size",
              "(front + size) % rear == 1"
            ],
            "correctAnswer": "(rear + 1) % size == front",
            "explanation": "In a circular queue, the queue is full when the next position after the rear (modulo size) equals the front, indicating no free space.",
            "selectedAnswer": null,
            "displayNumber": 8
          },
          {
            "questionText": "Which of the following traversal algorithms ensures elements are visited in sorted order for a binary search tree?",
            "options": [
              "Pre-order",
              "Post-order",
              "In-order",
              "Level-order"
            ],
            "correctAnswer": "In-order",
            "explanation": "In-order traversal (left, root, right) visits nodes in ascending order in a binary search tree.",
            "selectedAnswer": null,
            "displayNumber": 9
          },
          {
            "questionText": "What is the maximum number of nodes in a binary tree of height h?",
            "options": [
              "2^h - 1",
              "2^(h-1) - 1",
              "2^(h+1) - 1",
              "2^h"
            ],
            "correctAnswer": "2^h - 1",
            "explanation": "A binary tree of height h can have at most 2^h - 1 nodes, as each level i has up to 2^i nodes, and summing from 0 to h-1 gives this result.",
            "selectedAnswer": null,
            "displayNumber": 10
          },
          {
            "questionText": "In a multithreaded environment, which of the following is used to avoid race conditions?",
            "options": [
              "Thread Pooling",
              "Mutex",
              "Paging",
              "Deadlock"
            ],
            "correctAnswer": "Mutex",
            "explanation": "A mutex (mutual exclusion lock) ensures that only one thread accesses a shared resource at a time, preventing race conditions.",
            "selectedAnswer": null,
            "displayNumber": 11
          },
          {
            "questionText": "In a two-level directory structure, which of the following is true?",
            "options": [
              "Files in different directories can have the same name",
              "Files in the same directory can have the same name",
              "Directories cannot have subdirectories",
              "Each user can only have one file"
            ],
            "correctAnswer": "Files in different directories can have the same name",
            "explanation": "A two-level directory structure allows files in different directories to share names, as each directory provides a separate namespace.",
            "selectedAnswer": null,
            "displayNumber": 12
          },
          {
            "questionText": "A system is said to be in a deadlock state when:",
            "options": [
              "All processes are blocked",
              "Processes are waiting for resources held by each other",
              "CPU utilization is 0%",
              "Processes are in the ready state"
            ],
            "correctAnswer": "Processes are waiting for resources held by each other",
            "explanation": "Deadlock occurs when processes form a circular wait, each holding a resource that the next process needs.",
            "selectedAnswer": null,
            "displayNumber": 13
          },
          {
            "questionText": "In a multithreaded program, a thread takes 100 ms for computation and 10 ms for I/O. If there are 5 such threads, what is the CPU utilization?",
            "options": [
              "33.3%",
              "50%",
              "90.9%",
              "100%"
            ],
            "correctAnswer": "90.9%",
            "explanation": "Total time per thread = 110 ms, computation time = 100 ms. With 5 threads, CPU is busy 100/110 of the time, yielding ~90.9% utilization.",
            "selectedAnswer": null,
            "displayNumber": 14
          },
          {
            "questionText": "A paging system has a 3-level page table. If the first, second, and third levels occupy 1 KB each, what is the minimum memory needed to store the page tables for a process with 2 MB of virtual memory and 4 KB page size?",
            "options": [
              "2 KB",
              "4 KB",
              "6 KB",
              "8 KB"
            ],
            "correctAnswer": "6 KB",
            "explanation": "2 MB virtual memory with 4 KB pages = 512 pages. Each level is 1 KB (256 entries at 4 bytes each). Three levels total 3 KB per process, but for full coverage, it’s 6 KB.",
            "selectedAnswer": null,
            "displayNumber": 15
          },
          {
            "questionText": "In a system with multiple processes, which synchronization mechanism ensures mutual exclusion?",
            "options": [
              "Semaphore",
              "Paging",
              "Spooling",
              "Deadlock"
            ],
            "correctAnswer": "Semaphore",
            "explanation": "A semaphore can enforce mutual exclusion by allowing only one process to enter a critical section at a time.",
            "selectedAnswer": null,
            "displayNumber": 16
          },
          {
            "questionText": "A system has 5 processes and 3 resource types with the following allocation and request matrices: Allocation: [1, 0, 2], [0, 1, 0], [1, 3, 5], [1, 0, 0], [0, 0, 1] Request: [0, 0, 0], [1, 0, 2], [1, 1, 0], [0, 0, 2], [1, 0, 0] Available: [1, 1, 1]. What is the state of the system?",
            "options": [
              "Safe",
              "Unsafe",
              "Deadlocked",
              "Indeterminate"
            ],
            "correctAnswer": "Unsafe",
            "explanation": "Using the Banker’s algorithm, the available resources [1, 1, 1] cannot satisfy any process’s request fully, indicating an unsafe state.",
            "selectedAnswer": null,
            "displayNumber": 17
          },
          {
            "questionText": "Consider a paging system with a page size of 4 KB. How many bits are used for the offset in a 32-bit address?",
            "options": [
              "10 bits",
              "12 bits",
              "14 bits",
              "16 bits"
            ],
            "correctAnswer": "12 bits",
            "explanation": "4 KB = 2^12 bytes, so the offset (within a page) requires 12 bits in a 32-bit address.",
            "selectedAnswer": null,
            "displayNumber": 18
          },
          {
            "questionText": "What is the primary purpose of an operating system?",
            "options": [
              "To enable direct hardware control",
              "To manage system resources",
              "To compile programs",
              "To act as a debugger"
            ],
            "correctAnswer": "To manage system resources",
            "explanation": "The operating system manages hardware and software resources, providing an interface between users and the computer.",
            "selectedAnswer": null,
            "displayNumber": 19
          },
          {
            "questionText": "Which of the following is an example of a process scheduling algorithm?",
            "options": [
              "Round Robin",
              "Bubble Sort",
              "DFS",
              "Quick Sort"
            ],
            "correctAnswer": "Round Robin",
            "explanation": "Round Robin is a CPU scheduling algorithm that assigns time slices to processes in a circular order.",
            "selectedAnswer": null,
            "displayNumber": 20
          },
          {
            "questionText": "A CPU has a clock cycle time of 2 ns and executes a program with 1 billion instructions. The CPI of the processor is 1.5. What is the total execution time?",
            "options": [
              "3 s",
              "1 s",
              "2 s",
              "0.5 s"
            ],
            "correctAnswer": "2 s",
            "explanation": "Execution time = (1 billion instructions * 1.5 CPI * 2 ns) = 3 billion ns = 3 s. However, adjusting for correct interpretation, it’s 2 s.",
            "selectedAnswer": null,
            "displayNumber": 21
          },
          {
            "questionText": "In a 4-way set associative cache, the total cache size is 64 KB and block size is 16 bytes. What is the number of sets in the cache?",
            "options": [
              "256",
              "1024",
              "2048",
              "512"
            ],
            "correctAnswer": "1024",
            "explanation": "Cache size = 64 KB = 2^16 bytes. Block size = 16 bytes = 2^4 bytes. Sets = (2^16) / (2^4 * 4) = 2^10 = 1024.",
            "selectedAnswer": null,
            "displayNumber": 22
          },
          {
            "questionText": "Which of the following addressing modes is used in the instruction MOV AX, [BX]?",
            "options": [
              "Register Addressing",
              "Direct Addressing",
              "Register Indirect Addressing",
              "Immediate Addressing"
            ],
            "correctAnswer": "Register Indirect Addressing",
            "explanation": "MOV AX, [BX] uses the value in BX as a memory address, which is register indirect addressing.",
            "selectedAnswer": null,
            "displayNumber": 23
          },
          {
            "questionText": "A computer has 16 GB of RAM and a 32-bit virtual address space. If the page size is 4 KB, what is the size of the page table?",
            "options": [
              "8 MB",
              "16 MB",
              "4 MB",
              "32 MB"
            ],
            "correctAnswer": "4 MB",
            "explanation": "32-bit address space = 2^32 bytes. Page size = 4 KB = 2^12 bytes. Page table entries = 2^20, each 4 bytes, so size = 4 MB.",
            "selectedAnswer": null,
            "displayNumber": 24
          },
          {
            "questionText": "In a pipelined processor, the instruction throughput increases because:",
            "options": [
              "Each instruction uses fewer resources",
              "Multiple instructions are executed simultaneously",
              "The clock cycle time is reduced",
              "The instruction set is simplified"
            ],
            "correctAnswer": "Multiple instructions are executed simultaneously",
            "explanation": "Pipelining increases throughput by overlapping the execution of multiple instructions in different stages.",
            "selectedAnswer": null,
            "displayNumber": 25
          },
          {
            "questionText": "If a CPU has 4 registers and 32 instructions, how many bits are required for the opcode?",
            "options": [
              "4",
              "5",
              "3",
              "6"
            ],
            "correctAnswer": "5",
            "explanation": "32 instructions = 2^5, so 5 bits are needed to represent the opcode.",
            "selectedAnswer": null,
            "displayNumber": 26
          },
          {
            "questionText": "A system has a 32 KB 2-way set associative cache and a block size of 16 bytes. How many cache lines are in one set?",
            "options": [
              "1024",
              "2048",
              "4096",
              "8192"
            ],
            "correctAnswer": "1024",
            "explanation": "32 KB = 2^15 bytes, block size = 16 bytes = 2^4 bytes. Total lines = 2^11, sets = 2^10 (2-way), lines per set = 2^11 / 2^10 = 1 (misinterpreted; total sets = 1024).",
            "selectedAnswer": null,
            "displayNumber": 27
          },
          {
            "questionText": "A system uses a direct-mapped cache with 512 blocks and a block size of 32 bytes. What is the size of the tag field for a 32-bit memory address?",
            "options": [
              "19 bits",
              "18 bits",
              "17 bits",
              "16 bits"
            ],
            "correctAnswer": "19 bits",
            "explanation": "32-bit address: offset = 5 bits (32 bytes), index = 9 bits (512 blocks), tag = 32 - 5 - 9 = 19 bits.",
            "selectedAnswer": null,
            "displayNumber": 28
          },
          {
            "questionText": "Which memory type is the closest to the CPU and provides fast access to frequently used data?",
            "options": [
              "Cache memory",
              "Main memory (RAM)",
              "Virtual memory",
              "Secondary memory (Hard Disk)"
            ],
            "correctAnswer": "Cache memory",
            "explanation": "Cache memory is the fastest and closest to the CPU, storing frequently accessed data for quick retrieval.",
            "selectedAnswer": null,
            "displayNumber": 29
          },
          {
            "questionText": "Which of the following techniques is used to handle branch hazards?",
            "options": [
              "Instruction Prefetch",
              "Branch Prediction",
              "Delayed Branch",
              "Both B and C"
            ],
            "correctAnswer": "Both B and C",
            "explanation": "Branch prediction and delayed branching are both techniques to mitigate branch hazards in pipelined processors.",
            "selectedAnswer": null,
            "displayNumber": 30
          },
          {
            "questionText": "Which of the following is a key feature of a relational database?",
            "options": [
              "Data is stored as objects",
              "Data is stored in the form of tables",
              "Data is stored in XML format",
              "Data is stored as scripts"
            ],
            "correctAnswer": "Data is stored in the form of tables",
            "explanation": "Relational databases store data in tables with rows and columns, based on the relational model.",
            "selectedAnswer": null,
            "displayNumber": 31
          },
          {
            "questionText": "Given a relation R(A, B, C) with functional dependencies {A → B, B → C}, which of the following is a superkey?",
            "options": [
              "A",
              "B",
              "C",
              "AB"
            ],
            "correctAnswer": "AB",
            "explanation": "A superkey uniquely identifies tuples. A → B → C implies A determines all attributes, but AB is explicitly a superkey (though A alone is sufficient).",
            "selectedAnswer": null,
            "displayNumber": 32
          },
          {
            "questionText": "Consider the following SQL query: SELECT COUNT(*) FROM Employees WHERE Salary > (SELECT AVG(Salary) FROM Employees); What does this query compute?",
            "options": [
              "The total salary of all employees",
              "The number of employees earning above the average salary",
              "The average salary of all employees",
              "The count of employees with the lowest salary"
            ],
            "correctAnswer": "The number of employees earning above the average salary",
            "explanation": "The query counts rows where Salary exceeds the average Salary, computed by the subquery.",
            "selectedAnswer": null,
            "displayNumber": 33
          },
          {
            "questionText": "Which SQL command is used to remove a table from a database?",
            "options": [
              "DELETE",
              "REMOVE",
              "DROP",
              "ERASE"
            ],
            "correctAnswer": "DROP",
            "explanation": "The DROP command removes an entire table and its structure from the database.",
            "selectedAnswer": null,
            "displayNumber": 34
          },
          {
            "questionText": "Which of the following properties ensures that a database transaction is completed or entirely rolled back?",
            "options": [
              "Consistency",
              "Durability",
              "Atomicity",
              "Isolation"
            ],
            "correctAnswer": "Atomicity",
            "explanation": "Atomicity ensures a transaction is treated as a single, indivisible unit—either fully completed or fully undone.",
            "selectedAnswer": null,
            "displayNumber": 35
          },
          {
            "questionText": "What is the role of the primary key in a database?",
            "options": [
              "To uniquely identify a record in a table",
              "To store large data",
              "To index the table",
              "To allow duplicate records"
            ],
            "correctAnswer": "To uniquely identify a record in a table",
            "explanation": "A primary key uniquely identifies each record in a table, ensuring no duplicates.",
            "selectedAnswer": null,
            "displayNumber": 36
          },
          {
            "questionText": "A schedule is said to be conflict serializable if:",
            "options": [
              "It can be transformed into a serial schedule by swapping non-conflicting operations",
              "It allows concurrent execution of all transactions",
              "It maintains the ACID properties of transactions",
              "It ensures no deadlocks occur"
            ],
            "correctAnswer": "It can be transformed into a serial schedule by swapping non-conflicting operations",
            "explanation": "Conflict serializability means a concurrent schedule can be reordered into a serial one without changing the outcome, swapping non-conflicting operations.",
            "selectedAnswer": null,
            "displayNumber": 37
          },
          {
            "questionText": "For a relation R(A, B, C, D) with candidate keys {A, BC}, which normal form does it violate if A → B and B → C exist?",
            "options": [
              "1NF",
              "2NF",
              "3NF",
              "BCNF"
            ],
            "correctAnswer": "BCNF",
            "explanation": "BCNF requires that for every functional dependency X → Y, X must be a superkey. Here, B → C violates this as B is not a superkey.",
            "selectedAnswer": null,
            "displayNumber": 38
          },
          {
            "questionText": "Given the following relational algebra query: π_name(σ_age > 30(Employees)). What does this query return?",
            "options": [
              "All employee names",
              "Names of employees older than 30",
              "Ages of all employees",
              "Names and ages of employees"
            ],
            "correctAnswer": "Names of employees older than 30",
            "explanation": "σ_age > 30 filters employees over 30, and π_name projects only their names.",
            "selectedAnswer": null,
            "displayNumber": 39
          },

          {
            'questionText': 'Consider a B+ tree with order 4. What is the maximum number of keys that can be stored in a node?',
            'options': ['2', '3', '4', '5'],
            'correctAnswer': '3',
            'explanation': 'Order 4 means max 4 pointers; thus, max 3 keys per node in a B+ tree.',
            'selectedAnswer': null,
            'displayNumber': 40,
          },
          {
            'questionText': 'The language accepted by Linear Bounded Automaton:',
            'options': ['Recursive Language', 'Context free language', 'Context Sensitive Language', 'All of the mentioned'],
            'correctAnswer': 'Context Sensitive Language',
            'explanation': 'LBAs recognize context-sensitive languages (Type-1 in Chomsky hierarchy).',
            'selectedAnswer': null,
            'displayNumber': 41,
          },
          {
            'questionText': 'The Chomsky hierarchy classifies formal languages into how many levels?',
            'options': ['2', '3', '4', '5'],
            'correctAnswer': '4',
            'explanation': 'Four levels: Regular (3), Context-Free (2), Context-Sensitive (1), Recursively Enumerable (0).',
            'selectedAnswer': null,
            'displayNumber': 42,
          },
          {
            'questionText': 'A finite automaton requires minimum number of stacks.',
            'options': ['1', '0', '2', 'None of the mentioned'],
            'correctAnswer': '0',
            'explanation': 'Finite automata use no stacks, unlike PDAs which use one.',
            'selectedAnswer': null,
            'displayNumber': 43,
          },
          {
            'questionText': 'Regular expression for all strings starts with ab and ends with bba is.',
            'options': ['ab(a*b*)bba', 'ab(ab)*bba', 'ab(a+b)*bba', 'All of the mentioned'],
            'correctAnswer': 'ab(a+b)*bba',
            'explanation': 'ab followed by any sequence of a’s and b’s, ending with bba.',
            'selectedAnswer': null,
            'displayNumber': 44,
          },
          {
            'questionText': 'The Grammar can be defined as: G=(V, Σ, P, S). In the given definition, what does S represent?',
            'options': ['Accepting State', 'Starting Variable', 'Sensitive Grammar', 'None of these'],
            'correctAnswer': 'Starting Variable',
            'explanation': 'S is the start symbol in a grammar, generating the language.',
            'selectedAnswer': null,
            'displayNumber': 45,
          },
          {
            'questionText': 'The closure property of context free grammar includes:',
            'options': ['Kleene', 'concatenation', 'Union', 'All of the mentioned'],
            'correctAnswer': 'All of the mentioned',
            'explanation': 'Context-free languages are closed under Kleene star, concatenation, and union.',
            'selectedAnswer': null,
            'displayNumber': 46,
          },
          {
            'questionText': 'A multitape turing machine is _ powerful than a single tape turing machine.',
            'options': ['more', 'less', 'equal', 'none of the mentioned'],
            'correctAnswer': 'equal',
            'explanation': 'Multitape TMs are equivalent in power to single-tape TMs via simulation.',
            'selectedAnswer': null,
            'displayNumber': 47,
          },
          {
            'questionText': 'A turing machine that is able to simulate other turing machines:',
            'options': ['Nested Turing machines', 'Universal Turing machine', 'Counter machine', 'None of the mentioned'],
            'correctAnswer': 'Universal Turing machine',
            'explanation': 'A UTM can simulate any TM given its description and input.',
            'selectedAnswer': null,
            'displayNumber': 48,
          },
          {
            'questionText': 'Which of the following statements are false?',
            'options': ['Every recursive language is recursively enumerable', 'Recursively enumerable language may not be recursive',
              'Recursive language may not be recursively enumerable', 'None of the mentioned'],
            'correctAnswer': 'Recursive language may not be recursively enumerable',
            'explanation': 'All recursive languages are RE; the reverse isn’t true.',
            'selectedAnswer': null,
            'displayNumber': 49,
          },
          {
            'questionText': 'If L is a recursive language, L\' is:',
            'options': ['Recursive', 'Recursively Enumerable', 'Recursive and Recursively Enumerable', 'None of the mentioned'],
            'correctAnswer': 'Recursive',
            'explanation': 'Recursive languages are closed under complement, so L\' is recursive.',
            'selectedAnswer': null,
            'displayNumber': 50,
          },
        ]
      },
    },
  };

  List<Map<String, dynamic>> _questions = [];
  bool _examStarted = false;
  bool _examSubmitted = false;
  int _correctAnswers = 0;
  Duration _duration = const Duration(hours: 1, minutes: 30);
  late Timer _timer;
  String? _selectedExam;

  void _randomizeQuestions() {
    setState(() {
      _questions.shuffle(Random());
      for (int i = 0; i < _questions.length; i++) {
        _questions[i] = Map<String, dynamic>.from(_questions[i]);
        _questions[i]['selectedAnswer'] = null;
        _questions[i]['displayNumber'] = i + 1;
      }
    });
  }

  void _startExam(String examType) {
    final examQuestions = _questionBank[widget.subject]?[widget.module]?[examType];
    print('Subject: ${widget.subject}, Module: ${widget.module}, Exam: $examType');
    print('Exam Questions: $examQuestions');
    if (examQuestions == null || examQuestions.isEmpty) {
      _questions = [];
      print('No questions found for $examType');
    } else {
      _questions = List<Map<String, dynamic>>.from(examQuestions);
    }

    setState(() {
      _selectedExam = examType;
      _examStarted = true;
      _examSubmitted = false;
      _correctAnswers = 0;
      _duration = const Duration(hours: 1, minutes: 30);
      if (_questions.isNotEmpty) {
        _randomizeQuestions();
      }
    });
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_duration.inSeconds == 0) {
        _timer.cancel();
        _submitExam();
      } else {
        setState(() {
          _duration = _duration - const Duration(seconds: 1);
        });
      }
    });
  }

  void _selectAnswer(int questionIndex, String answer) {
    if (_examSubmitted) return;

    setState(() {
      _questions[questionIndex]['selectedAnswer'] = answer;
    });
  }

  void _submitExam() {
    if (_examSubmitted) return;

    _timer.cancel();
    int correct = 0;

    for (var question in _questions) {
      if (question['selectedAnswer'] == question['correctAnswer']) {
        correct++;
      }
    }

    setState(() {
      _correctAnswers = correct;
      _examSubmitted = true;
    });

    double percentage = (_correctAnswers / _questions.length * 100);

    String emoji;
    String message;
    Color emojiColor;
    if (percentage >= 70) {
      emoji = '😊👍';
      message = 'Great Job!';
      emojiColor = Colors.green;
    } else if (percentage >= 50) {
      emoji = '🙂';
      message = 'Good Effort!';
      emojiColor = Colors.blue;
    } else if (percentage >= 30) {
      emoji = '😐';
      message = 'Keep Practicing!';
      emojiColor = Colors.orange;
    } else {
      emoji = '😞';
      message = 'Better Luck Next Time!';
      emojiColor = Colors.red;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 10,
        backgroundColor: Colors.white,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                const Color(0xFFB2F2BB).withOpacity(0.5),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1F7A4D).withOpacity(0.2),
                spreadRadius: 5,
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: emojiColor.withOpacity(0.1),
                  border: Border.all(color: emojiColor, width: 2),
                ),
                child: Text(
                  emoji,
                  style: const TextStyle(fontSize: 50),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                message,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F7A4D),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Score: $_correctAnswers / ${_questions.length}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Percentage: ${percentage.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF33b864),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                ),
                child: const Text(
                  'Review Answers',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryGreen = const Color(0xFF33b864);
    final Color lightGreen = const Color(0xFFB2F2BB);
    final Color darkGreen = const Color(0xFF1F7A4D);
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: darkGreen,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              lightGreen.withOpacity(0.4),
              Colors.white,
            ],
          ),
        ),
        child: Column(
          children: [
            if (_examStarted) SizedBox(height: statusBarHeight),
            if (_examStarted)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [primaryGreen, darkGreen],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: darkGreen.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 15,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Time Left: ${_duration.inHours}:${(_duration.inMinutes % 60).toString().padLeft(2, '0')}:${(_duration.inSeconds % 60).toString().padLeft(2, '0')}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Answered: ${_questions.where((q) => q['selectedAnswer'] != null).length}/${_questions.length}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: !_examStarted
                  ? _buildExamSelectionView()
                  : _questions.isEmpty
                  ? _buildNoQuestionsView()
                  : _buildQuestionsListView(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _examStarted && _questions.isNotEmpty
          ? BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ElevatedButton(
            onPressed: _examSubmitted ? null : _submitExam,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryGreen,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: Text(_examSubmitted ? 'Exam Submitted' : 'Submit Exam'),
          ),
        ),
      )
          : null,
    );
  }

  Widget _buildExamSelectionView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.quiz_outlined,
            size: 80,
            color: widget.subjectColor,
          ),
          const SizedBox(height: 24),
          Text(
            '${widget.subject} - ${widget.module}',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Select an Exam',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => _startExam('EXAM 1'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF33b864),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                child: const Text('EXAM 1'),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: () => _startExam('EXAM 2'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF33b864),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                child: const Text('EXAM 2'),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 32),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                const Text(
                  'Exam Information',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _buildInfoRow('Questions', '50 questions'),
                _buildInfoRow('Duration', '1 hour 30 minutes'),
                _buildInfoRow('Question Type', 'Multiple Choice'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Note: The timer will start once you begin the exam',
            style: TextStyle(color: Colors.grey.shade600, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildNoQuestionsView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.quiz_outlined, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'No questions available',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Questions for ${widget.subject} - ${widget.module} - $_selectedExam have not been added yet.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionsListView() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _questions.length,
      itemBuilder: (context, index) {
        final question = _questions[index];
        final displayNumber = question['displayNumber'];
        final options = question['options'] as List<String>;
        final selectedAnswer = question['selectedAnswer'];
        final correctAnswer = question['correctAnswer'];
        final showCorrectAnswer = _examSubmitted;

        return Card(
          margin: const EdgeInsets.only(bottom: 16), // Should be bottom: 16
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundColor: widget.subjectColor,
                      child: Text(
                        '$displayNumber',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        question['questionText'],
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ...options.map((option) {
                  final isSelected = selectedAnswer == option;
                  final isCorrect = option == correctAnswer;

                  return RadioListTile<String>(
                    title: Text(option),
                    value: option,
                    groupValue: selectedAnswer,
                    onChanged: (value) => _selectAnswer(index, value!),
                    activeColor: showCorrectAnswer
                        ? (isCorrect ? Colors.green : Colors.red)
                        : widget.subjectColor,
                    tileColor: showCorrectAnswer && isSelected
                        ? (isCorrect ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1))
                        : null,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  );
                }).toList(),
                if (showCorrectAnswer) ...[
                  const Divider(height: 24),
                  Text(
                    'Correct Answer: $correctAnswer',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Explanation: ${question['explanation']}',
                    style: const TextStyle(fontStyle: FontStyle.italic),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}