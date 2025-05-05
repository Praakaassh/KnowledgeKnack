import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../../../main.dart';

const Color primaryGreen = Color(0xFF33b864);
const Color lightGreen = Color(0xFFB2F2BB);
const Color darkGreen = Color(0xFF1F7A4D);

class SubjectWiseMockTestPage extends StatefulWidget {
  final String subject;
  final Color subjectColor;

  const SubjectWiseMockTestPage({
    super.key,
    required this.subject,
    required this.subjectColor,
  });

  @override
  State<SubjectWiseMockTestPage> createState() => _SubjectWiseMockTestPageState();
}

class _SubjectWiseMockTestPageState extends State<SubjectWiseMockTestPage> {
  bool _testStarted = false;
  bool _testSubmitted = false;
  int _correctAnswers = 0;
  Duration _duration = const Duration(minutes: 30); // 30 minutes for mock test
  late Timer _timer;

  final Map<String, List<Map<String, dynamic>>> _questionBank = {
    'COA': [
      {
        'questionText': 'Which of the following is the fastest memory?',
        'options': ['RAM', 'Cache Memory', 'Hard Disk', 'Register'],
        'correctAnswer': 'Register',
        'explanation': 'Registers are the fastest memory type, located inside the CPU, offering the quickest access time.',
        'selectedAnswer': null,
        'displayNumber': 1
      },
      {
        'questionText': 'The ALU of a computer system is responsible for:',
        'options': ['Arithmetic operations only', 'Logical operations only', 'Both arithmetic and logical operations', 'Memory operations'],
        'correctAnswer': 'Both arithmetic and logical operations',
        'explanation': 'The Arithmetic Logic Unit (ALU) performs both arithmetic (e.g., addition) and logical (e.g., AND, OR) operations.',
        'selectedAnswer': null,
        'displayNumber': 2
      },
      {
        'questionText': 'The performance of a processor is measured in terms of:',
        'options': ['Clock Speed', 'CPI (Cycles Per Instruction)', 'MIPS (Million Instructions Per Second)', 'All of the above'],
        'correctAnswer': 'All of the above',
        'explanation': 'Processor performance is assessed using clock speed (frequency), CPI (efficiency per cycle), and MIPS (instruction throughput).',
        'selectedAnswer': null,
        'displayNumber': 3
      },
      {
        'questionText': 'The control unit in a CPU is responsible for:',
        'options': ['Arithmetic operations', 'Logical operations', 'Fetching and executing instructions', 'Storing data'],
        'correctAnswer': 'Fetching and executing instructions',
        'explanation': 'The control unit manages the fetch-decode-execute cycle, directing instruction execution.',
        'selectedAnswer': null,
        'displayNumber': 4
      },
      {
        'questionText': 'Which of the following is a RISC processor?',
        'options': ['Intel Pentium', 'ARM', 'AMD Ryzen', 'Intel Core i7'],
        'correctAnswer': 'ARM',
        'explanation': 'ARM processors follow the Reduced Instruction Set Computing (RISC) design, emphasizing simplicity and efficiency.',
        'selectedAnswer': null,
        'displayNumber': 5
      },
      {
        'questionText': 'The number of bits used to address memory locations in a system with 16-bit address bus is:',
        'options': ['2^16', '2^8', '2^4', '2^32'],
        'correctAnswer': '2^16',
        'explanation': 'A 16-bit address bus can address 2^16 (65,536) unique memory locations.',
        'selectedAnswer': null,
        'displayNumber': 6
      },
      {
        'questionText': 'The instruction cycle consists of:',
        'options': ['Fetch, Decode, Execute', 'Fetch and Execute', 'Decode and Execute', 'Only Execute'],
        'correctAnswer': 'Fetch, Decode, Execute',
        'explanation': 'The instruction cycle includes fetching the instruction, decoding it, and executing it.',
        'selectedAnswer': null,
        'displayNumber': 7
      },
      {
        'questionText': 'The Von Neumann architecture uses:',
        'options': ['Separate memory for data and instructions', 'A single memory for data and instructions', 'No memory', 'Only cache memory'],
        'correctAnswer': 'A single memory for data and instructions',
        'explanation': 'Von Neumann architecture stores both data and instructions in a single shared memory.',
        'selectedAnswer': null,
        'displayNumber': 8
      },
      {
        'questionText': 'The effective address in indirect addressing mode is found in:',
        'options': ['Instruction itself', 'Register', 'Memory location pointed by instruction', 'Stack'],
        'correctAnswer': 'Memory location pointed by instruction',
        'explanation': 'In indirect addressing, the instruction points to a memory location that contains the effective address.',
        'selectedAnswer': null,
        'displayNumber': 9
      },
      {
        'questionText': 'The instruction "ADD R1, R2, R3" in assembly language means:',
        'options': ['Add the contents of R1 and R2 and store in R3', 'Add the contents of R2 and R3 and store in R1', 'Add the contents of R1 and R3 and store in R2', 'None of the above'],
        'correctAnswer': 'Add the contents of R1 and R2 and store in R3',
        'explanation': 'In this format, R1 and R2 are operands, and the result is stored in R3.',
        'selectedAnswer': null,
        'displayNumber': 10
      },
      {
        'questionText': 'Pipelining improves CPU performance by:',
        'options': ['Reducing execution time', 'Overlapping instruction execution', 'Increasing clock speed', 'Increasing memory size'],
        'correctAnswer': 'Overlapping instruction execution',
        'explanation': 'Pipelining allows multiple instructions to be processed simultaneously by overlapping their stages.',
        'selectedAnswer': null,
        'displayNumber': 11
      },
      {
        'questionText': 'The primary function of cache memory is to:',
        'options': ['Store frequently accessed data', 'Replace RAM', 'Increase the speed of the hard disk', 'Store permanent data'],
        'correctAnswer': 'Store frequently accessed data',
        'explanation': 'Cache memory holds frequently used data to reduce access time to main memory.',
        'selectedAnswer': null,
        'displayNumber': 12
      },
      {
        'questionText': 'Which of the following is a non-volatile memory?',
        'options': ['SRAM', 'DRAM', 'ROM', 'Cache'],
        'correctAnswer': 'ROM',
        'explanation': 'Read-Only Memory (ROM) retains data even without power, making it non-volatile.',
        'selectedAnswer': null,
        'displayNumber': 13
      },
      {
        'questionText': 'The clock rate of a processor is determined by:',
        'options': ['Number of ALU units', 'Cache size', 'System clock', 'Operating System'],
        'correctAnswer': 'System clock',
        'explanation': 'The system clock dictates the processor’s clock rate, measured in Hz.',
        'selectedAnswer': null,
        'displayNumber': 14
      },
      {
        'questionText': 'The time taken by the CPU to execute an instruction is called:',
        'options': ['Clock Cycle', 'Execution Time', 'Instruction Time', 'CPI (Cycles Per Instruction)'],
        'correctAnswer': 'Execution Time',
        'explanation': 'Execution Time refers to the total time taken to complete an instruction.',
        'selectedAnswer': null,
        'displayNumber': 15
      },
      {
        'questionText': 'In which addressing mode does the operand reside in memory and its address is specified in the instruction?',
        'options': ['Direct Addressing', 'Indirect Addressing', 'Register Addressing', 'Immediate Addressing'],
        'correctAnswer': 'Direct Addressing',
        'explanation': 'Direct addressing specifies the memory address of the operand in the instruction.',
        'selectedAnswer': null,
        'displayNumber': 16
      },
      {
        'questionText': 'The size of a word in a computer is determined by:',
        'options': ['The number of address lines', 'The number of data lines', 'The number of bits in a register', 'The size of the ALU'],
        'correctAnswer': 'The number of bits in a register',
        'explanation': 'Word size typically matches the number of bits a CPU register can process at once.',
        'selectedAnswer': null,
        'displayNumber': 17
      },
      {
        'questionText': 'The instruction format for RISC architecture typically includes:',
        'options': ['Multiple addressing modes', 'Variable-length instructions', 'Fixed-length instructions', 'Complex instruction decoding'],
        'correctAnswer': 'Fixed-length instructions',
        'explanation': 'RISC uses fixed-length instructions for simplicity and efficient decoding.',
        'selectedAnswer': null,
        'displayNumber': 18
      },
      {
        'questionText': 'The purpose of a Program Counter (PC) is to:',
        'options': ['Store the address of the next instruction', 'Store the instruction being executed', 'Count the number of instructions', 'Store temporary data'],
        'correctAnswer': 'Store the address of the next instruction',
        'explanation': 'The Program Counter holds the address of the next instruction to be fetched.',
        'selectedAnswer': null,
        'displayNumber': 19
      },
      {
        'questionText': 'The Harvard architecture uses:',
        'options': ['A single memory for data and instructions', 'Separate memory for data and instructions', 'No memory', 'Only cache memory'],
        'correctAnswer': 'Separate memory for data and instructions',
        'explanation': 'Harvard architecture separates data and instruction memory for concurrent access.',
        'selectedAnswer': null,
        'displayNumber': 20
      },
      {
        'questionText': 'The control signals in a CPU are generated by:',
        'options': ['Data bus', 'Address bus', 'Control unit', 'ALU'],
        'correctAnswer': 'Control unit',
        'explanation': 'The control unit generates signals to coordinate CPU operations.',
        'selectedAnswer': null,
        'displayNumber': 21
      },
      {
        'questionText': 'A microprogrammed control unit is implemented using:',
        'options': ['Hardwired logic', 'ROM-based control memory', 'Cache memory', 'RAM'],
        'correctAnswer': 'ROM-based control memory',
        'explanation': 'Microprogrammed control units store control signals in ROM for flexibility.',
        'selectedAnswer': null,
        'displayNumber': 22
      },
      {
        'questionText': 'The hit ratio of a cache memory is defined as:',
        'options': ['Number of cache misses', 'Number of cache hits divided by total memory accesses', 'Size of cache memory', 'Number of blocks in cache'],
        'correctAnswer': 'Number of cache hits divided by total memory accesses',
        'explanation': 'Hit ratio measures cache efficiency as the fraction of successful accesses.',
        'selectedAnswer': null,
        'displayNumber': 23
      },
      {
        'questionText': 'The technique of using multiple ALUs to execute several instructions at the same time is known as:',
        'options': ['Pipelining', 'Superscalar Execution', 'Multithreading', 'Cache Mapping'],
        'correctAnswer': 'Superscalar Execution',
        'explanation': 'Superscalar execution uses multiple ALUs to process instructions in parallel.',
        'selectedAnswer': null,
        'displayNumber': 24
      },
      {
        'questionText': 'The main function of a DMA controller is to:',
        'options': ['Control the CPU execution', 'Transfer data between memory and peripherals without CPU intervention', 'Control the data bus', 'Manage input/output devices'],
        'correctAnswer': 'Transfer data between memory and peripherals without CPU intervention',
        'explanation': 'DMA (Direct Memory Access) offloads data transfer tasks from the CPU.',
        'selectedAnswer': null,
        'displayNumber': 25
      },
      {
        'questionText': 'The function of an instruction decoder is to:',
        'options': ['Convert high-level code to assembly language', 'Convert instructions into micro-operations', 'Execute arithmetic operations', 'Control memory access'],
        'correctAnswer': 'Convert instructions into micro-operations',
        'explanation': 'The decoder translates instructions into micro-operations for execution.',
        'selectedAnswer': null,
        'displayNumber': 26
      },
      {
        'questionText': 'Which of the following is an example of an I/O-mapped I/O system?',
        'options': ['Memory-mapped I/O', 'DMA', 'Isolated I/O', 'Direct I/O'],
        'correctAnswer': 'Isolated I/O',
        'explanation': 'Isolated I/O uses separate address spaces for I/O devices, unlike memory-mapped I/O.',
        'selectedAnswer': null,
        'displayNumber': 27
      },
      {
        'questionText': 'Which of the following buses carries the actual data?',
        'options': ['Data bus', 'Address bus', 'Control bus', 'Instruction bus'],
        'correctAnswer': 'Data bus',
        'explanation': 'The data bus transfers actual data between components.',
        'selectedAnswer': null,
        'displayNumber': 28
      },
      {
        'questionText': 'The instruction "MOV R1, R2" means:',
        'options': ['Move data from R1 to R2', 'Move data from R2 to R1', 'Swap values of R1 and R2', 'Copy data to memory'],
        'correctAnswer': 'Move data from R2 to R1',
        'explanation': 'MOV typically copies data from the source (R2) to the destination (R1).',
        'selectedAnswer': null,
        'displayNumber': 29
      },
      {
        'questionText': 'The LRU (Least Recently Used) algorithm is used in:',
        'options': ['Cache replacement', 'Process scheduling', 'Memory allocation', 'Disk scheduling'],
        'correctAnswer': 'Cache replacement',
        'explanation': 'LRU replaces the least recently used cache block to optimize memory usage.',
        'selectedAnswer': null,
        'displayNumber': 30
      },
      {
        'questionText': 'Which of the following is used to reduce the number of memory accesses in pipelining?',
        'options': ['Cache Memory', 'Register Renaming', 'Instruction Buffer', 'Data Forwarding'],
        'correctAnswer': 'Data Forwarding',
        'explanation': 'Data forwarding reduces memory accesses by passing data directly between pipeline stages.',
        'selectedAnswer': null,
        'displayNumber': 31
      },
      {
        'questionText': 'The term "bus arbitration" refers to:',
        'options': ['Deciding which process gets CPU time', 'Resolving conflicts for bus access', 'Allocating cache memory', 'Managing memory hierarchy'],
        'correctAnswer': 'Resolving conflicts for bus access',
        'explanation': 'Bus arbitration determines which device gets control of the bus when multiple request it.',
        'selectedAnswer': null,
        'displayNumber': 32
      },
      {
        'questionText': 'Which of the following instructions belongs to the data transfer category?',
        'options': ['ADD', 'MOV', 'AND', 'JUMP'],
        'correctAnswer': 'MOV',
        'explanation': 'MOV is a data transfer instruction, unlike ADD (arithmetic) or JUMP (control).',
        'selectedAnswer': null,
        'displayNumber': 33
      },
      {
        'questionText': 'A processor with 2 GHz clock speed executes an instruction in 2 clock cycles. What is its instruction execution rate?',
        'options': ['1 GHz', '2 GHz', '500 MIPS', '1 MIPS'],
        'correctAnswer': '1 GHz',
        'explanation': 'Execution rate = Clock speed / Cycles per instruction = 2 GHz / 2 = 1 billion instructions per second (1 GHz).',
        'selectedAnswer': null,
        'displayNumber': 34
      },
      {
        'questionText': 'Which of the following addressing modes is used in an instruction like "ADD R1, (R2)"?',
        'options': ['Register Addressing', 'Direct Addressing', 'Indirect Addressing', 'Immediate Addressing'],
        'correctAnswer': 'Indirect Addressing',
        'explanation': 'The (R2) notation indicates the operand’s address is in R2, typical of indirect addressing.',
        'selectedAnswer': null,
        'displayNumber': 35
      },
      {
        'questionText': 'The main function of an instruction register (IR) is to:',
        'options': ['Store temporary data', 'Store the next instruction\'s address', 'Hold the instruction being executed', 'Control data flow'],
        'correctAnswer': 'Hold the instruction being executed',
        'explanation': 'The Instruction Register (IR) holds the current instruction during decoding and execution.',
        'selectedAnswer': null,
        'displayNumber': 36
      },
      {
        'questionText': 'If a CPU uses a 5-stage pipeline, how many instructions are executed simultaneously in an ideal case?',
        'options': ['1', '2', '5', '10'],
        'correctAnswer': '5',
        'explanation': 'In an ideal 5-stage pipeline, one instruction occupies each stage, allowing 5 to be processed concurrently.',
        'selectedAnswer': null,
        'displayNumber': 37
      },
      {
        'questionText': 'Which of the following is a CISC (Complex Instruction Set Computing) processor?',
        'options': ['ARM', 'Intel 8086', 'RISC-V', 'MIPS'],
        'correctAnswer': 'Intel 8086',
        'explanation': 'Intel 8086 is a CISC processor with complex, variable-length instructions.',
        'selectedAnswer': null,
        'displayNumber': 38
      },
      {
        'questionText': 'Which register in the CPU is used to store temporary data for processing?',
        'options': ['Program Counter', 'Accumulator', 'Stack Pointer', 'Base Register'],
        'correctAnswer': 'Accumulator',
        'explanation': 'The accumulator temporarily holds data during arithmetic and logical operations.',
        'selectedAnswer': null,
        'displayNumber': 39
      },
      {
        'questionText': 'If a cache uses 4-way set associative mapping, how many blocks can be stored in each set?',
        'options': ['1', '2', '4', '8'],
        'correctAnswer': '4',
        'explanation': 'In 4-way set associative mapping, each set can hold 4 blocks.',
        'selectedAnswer': null,
        'displayNumber': 40
      },
      {
        'questionText': 'Which of the following is NOT a function of an operating system in memory management?',
        'options': ['Process Scheduling', 'Cache Replacement', 'Address Translation', 'Virtual Memory Management'],
        'correctAnswer': 'Cache Replacement',
        'explanation': 'Cache replacement is handled by hardware, not the operating system.',
        'selectedAnswer': null,
        'displayNumber': 41
      },
      {
        'questionText': 'Which of the following cache replacement policies is most optimal?',
        'options': ['Least Recently Used (LRU)', 'First-In-First-Out (FIFO)', 'Random Replacement', 'Optimal Page Replacement'],
        'correctAnswer': 'Optimal Page Replacement',
        'explanation': 'Optimal Page Replacement, though theoretical, replaces the page least likely to be used next, making it the most efficient.',
        'selectedAnswer': null,
        'displayNumber': 42
      },
      {
        'questionText': 'Which part of a computer is responsible for managing interrupts?',
        'options': ['CPU', 'Memory', 'Interrupt Controller', 'Bus'],
        'correctAnswer': 'Interrupt Controller',
        'explanation': 'The interrupt controller prioritizes and signals interrupts to the CPU.',
        'selectedAnswer': null,
        'displayNumber': 43
      },
      {
        'questionText': 'The execution time of a program is affected by:',
        'options': ['CPU clock speed', 'Instruction set efficiency', 'Memory hierarchy performance', 'All of the above'],
        'correctAnswer': 'All of the above',
        'explanation': 'Execution time depends on clock speed, instruction efficiency, and memory access speeds.',
        'selectedAnswer': null,
        'displayNumber': 44
      },
      {
        'questionText': 'The "write-through" cache strategy means:',
        'options': ['Data is written only to cache', 'Data is written to both cache and memory simultaneously', 'Data is stored in a buffer before writing to memory', 'Data is written to memory only when cache is full'],
        'correctAnswer': 'Data is written to both cache and memory simultaneously',
        'explanation': 'Write-through ensures data consistency by updating both cache and main memory at once.',
        'selectedAnswer': null,
        'displayNumber': 45
      },
      {
        'questionText': 'The instruction "PUSH R1" in assembly language means:',
        'options': ['Move data from R1 to memory', 'Copy data from memory to R1', 'Store R1 onto the stack', 'Load data from stack into R1'],
        'correctAnswer': 'Store R1 onto the stack',
        'explanation': 'PUSH places the contents of R1 onto the top of the stack.',
        'selectedAnswer': null,
        'displayNumber': 46
      },
      {
        'questionText': 'What is the main difference between DRAM and SRAM?',
        'options': ['DRAM is faster than SRAM', 'SRAM requires periodic refreshing, DRAM does not', 'DRAM needs refreshing, while SRAM does not', 'SRAM is used for main memory, DRAM for cache'],
        'correctAnswer': 'DRAM needs refreshing, while SRAM does not',
        'explanation': 'DRAM requires periodic refreshing to retain data, whereas SRAM does not.',
        'selectedAnswer': null,
        'displayNumber': 47
      },
      {
        'questionText': 'Which of the following components is responsible for translating virtual addresses into physical addresses?',
        'options': ['ALU', 'TLB (Translation Lookaside Buffer)', 'Cache Controller', 'CPU'],
        'correctAnswer': 'TLB (Translation Lookaside Buffer)',
        'explanation': 'The TLB speeds up virtual-to-physical address translation in memory management.',
        'selectedAnswer': null,
        'displayNumber': 48
      },
      {
        'questionText': 'The "fetch-execute cycle" in a CPU consists of:',
        'options': ['Fetching instructions and executing them', 'Fetching operands, executing, and storing results', 'Fetching, decoding, executing, and storing results', 'Fetching from memory and storing in cache'],
        'correctAnswer': 'Fetching, decoding, executing, and storing results',
        'explanation': 'The fetch-execute cycle includes fetching, decoding, executing, and storing results.',
        'selectedAnswer': null,
        'displayNumber': 49
      },
      {
        'questionText': 'In a multiprocessor system, the main advantage of a shared-memory architecture is:',
        'options': ['Faster execution speed', 'No need for communication between processors', 'Higher flexibility in workload management', 'Efficient data sharing among processors'],
        'correctAnswer': 'Efficient data sharing among processors',
        'explanation': 'Shared-memory architecture allows processors to access common data easily, enhancing coordination.',
        'selectedAnswer': null,
        'displayNumber': 50
      }
    ],
    'DBMS': [
      {
        'questionText': 'Which of the following is NOT a characteristic of a database?',
        'options': ['Self-describing nature', 'Isolation of data and programs', 'Data redundancy', 'Multi-user support'],
        'correctAnswer': 'Data redundancy',
        'explanation': 'Data redundancy is not a desirable characteristic of a database; databases aim to minimize redundancy to ensure data integrity and efficiency.',
        'selectedAnswer': null,
        'displayNumber': 1
      },
      {
        'questionText': 'Which type of database model organizes data into tables?',
        'options': ['Hierarchical Model', 'Network Model', 'Relational Model', 'Object-Oriented Model'],
        'correctAnswer': 'Relational Model',
        'explanation': 'The Relational Model organizes data into tables (relations) with rows and columns, linked by keys.',
        'selectedAnswer': null,
        'displayNumber': 2
      },
      {
        'questionText': 'Which component of DBMS handles the interaction with the file system?',
        'options': ['Query Processor', 'Transaction Manager', 'Storage Manager', 'Buffer Manager'],
        'correctAnswer': 'Storage Manager',
        'explanation': 'The Storage Manager interacts with the file system to store, retrieve, and manage data on disk.',
        'selectedAnswer': null,
        'displayNumber': 3
      },
      {
        'questionText': 'Which of the following is an example of a DBMS?',
        'options': ['MySQL', 'Python', 'HTML', 'Windows'],
        'correctAnswer': 'MySQL',
        'explanation': 'MySQL is a widely used Database Management System (DBMS), unlike the others which are not DBMS.',
        'selectedAnswer': null,
        'displayNumber': 4
      },
      {
        'questionText': 'Which term refers to the actual data stored in a database at a particular time?',
        'options': ['Schema', 'Instance', 'Attribute', 'Relation'],
        'correctAnswer': 'Instance',
        'explanation': 'An instance is the actual data stored in a database at a specific moment, while a schema defines its structure.',
        'selectedAnswer': null,
        'displayNumber': 5
      },
      {
        'questionText': 'Which type of database model uses a parent-child relationship?',
        'options': ['Network Model', 'Hierarchical Model', 'Relational Model', 'Object-Oriented Model'],
        'correctAnswer': 'Hierarchical Model',
        'explanation': 'The Hierarchical Model organizes data in a tree-like structure with parent-child relationships.',
        'selectedAnswer': null,
        'displayNumber': 6
      },
      {
        'questionText': 'Which of the following describes a weak entity?',
        'options': ['An entity with no primary key', 'An entity that contains redundant data', 'An entity that has no attributes', 'An entity that has only composite attributes'],
        'correctAnswer': 'An entity with no primary key',
        'explanation': 'A weak entity depends on another entity and does not have a primary key of its own.',
        'selectedAnswer': null,
        'displayNumber': 7
      },
      {
        'questionText': 'Which of the following symbols represents a relationship in an ER diagram?',
        'options': ['Rectangle', 'Ellipse', 'Diamond', 'Line'],
        'correctAnswer': 'Diamond',
        'explanation': 'In an ER diagram, a diamond symbol represents a relationship between entities.',
        'selectedAnswer': null,
        'displayNumber': 8
      },
      {
        'questionText': 'What is the role of a database administrator (DBA)?',
        'options': ['Designing ER diagrams', 'Writing application programs', 'Managing database access and performance', 'Performing data mining'],
        'correctAnswer': 'Managing database access and performance',
        'explanation': 'A DBA is responsible for managing database access, security, and optimizing performance.',
        'selectedAnswer': null,
        'displayNumber': 9
      },
      {
        'questionText': 'Which of the following is NOT a type of attribute in an ER model?',
        'options': ['Derived attribute', 'Multi-valued attribute', 'Primary attribute', 'Composite attribute'],
        'correctAnswer': 'Primary attribute',
        'explanation': 'Primary attribute is not a standard type in ER models; the others are well-defined attribute types.',
        'selectedAnswer': null,
        'displayNumber': 10
      },
      {
        'questionText': 'Which of the following is NOT a property of a relational database table?',
        'options': ['Each column has a unique name', 'All columns must be of the same data type', 'Rows must be unique', 'Order of rows does not matter'],
        'correctAnswer': 'All columns must be of the same data type',
        'explanation': 'Columns in a relational table can have different data types; this is not a requirement.',
        'selectedAnswer': null,
        'displayNumber': 11
      },
      {
        'questionText': 'A relation in a database is represented as a:',
        'options': ['Row', 'Column', 'Table', 'Field'],
        'correctAnswer': 'Table',
        'explanation': 'In a relational database, a relation is represented as a table with rows and columns.',
        'selectedAnswer': null,
        'displayNumber': 12
      },
      {
        'questionText': 'Which operation is used to retrieve specific columns from a relation?',
        'options': ['Selection', 'Projection', 'Join', 'Union'],
        'correctAnswer': 'Projection',
        'explanation': 'Projection retrieves specific columns from a relation, reducing the attributes displayed.',
        'selectedAnswer': null,
        'displayNumber': 13
      },
      {
        'questionText': 'A primary key must be:',
        'options': ['Unique', 'Null', 'Composite', 'Foreign'],
        'correctAnswer': 'Unique',
        'explanation': 'A primary key must uniquely identify each record and cannot contain NULL values.',
        'selectedAnswer': null,
        'displayNumber': 14
      },
      {
        'questionText': 'Which normal form eliminates partial dependency?',
        'options': ['1NF', '2NF', '3NF', 'BCNF'],
        'correctAnswer': '2NF',
        'explanation': 'Second Normal Form (2NF) eliminates partial dependencies on the primary key.',
        'selectedAnswer': null,
        'displayNumber': 15
      },
      {
        'questionText': 'Which of the following constraints ensures a column cannot have NULL values?',
        'options': ['PRIMARY KEY', 'UNIQUE', 'NOT NULL', 'FOREIGN KEY'],
        'correctAnswer': 'NOT NULL',
        'explanation': 'The NOT NULL constraint ensures that a column cannot contain NULL values.',
        'selectedAnswer': null,
        'displayNumber': 16
      },
      {
        'questionText': 'Which SQL command is used to remove duplicate rows from the result set?',
        'options': ['DISTINCT', 'UNIQUE', 'DELETE', 'REMOVE'],
        'correctAnswer': 'DISTINCT',
        'explanation': 'DISTINCT removes duplicate rows from the result set of a SELECT query.',
        'selectedAnswer': null,
        'displayNumber': 17
      },
      {
        'questionText': 'Which of the following operations is NOT part of relational algebra?',
        'options': ['Cartesian Product', 'Aggregation', 'Projection', 'Selection'],
        'correctAnswer': 'Aggregation',
        'explanation': 'Aggregation is not a basic relational algebra operation; it is an extended feature.',
        'selectedAnswer': null,
        'displayNumber': 18
      },
      {
        'questionText': 'Which SQL keyword is used to fetch only common records between two tables?',
        'options': ['UNION', 'INTERSECT', 'JOIN', 'DIFFERENCE'],
        'correctAnswer': 'INTERSECT',
        'explanation': 'INTERSECT returns only the common records between two result sets.',
        'selectedAnswer': null,
        'displayNumber': 19
      },
      {
        'questionText': 'Which of the following is a DML (Data Manipulation Language) command?',
        'options': ['CREATE', 'ALTER', 'INSERT', 'DROP'],
        'correctAnswer': 'INSERT',
        'explanation': 'INSERT is a DML command used to manipulate data, unlike the others which are DDL commands.',
        'selectedAnswer': null,
        'displayNumber': 20
      },
      {
        'questionText': 'Which SQL command is used to retrieve data from a database?',
        'options': ['SELECT', 'RETRIEVE', 'GET', 'DISPLAY'],
        'correctAnswer': 'SELECT',
        'explanation': 'SELECT is the SQL command used to retrieve data from a database.',
        'selectedAnswer': null,
        'displayNumber': 21
      },
      {
        'questionText': 'Which SQL clause is used to filter records?',
        'options': ['FROM', 'WHERE', 'ORDER BY', 'GROUP BY'],
        'correctAnswer': 'WHERE',
        'explanation': 'The WHERE clause filters records based on specified conditions.',
        'selectedAnswer': null,
        'displayNumber': 22
      },
      {
        'questionText': 'Which SQL function is used to find the highest value in a column?',
        'options': ['MIN()', 'MAX()', 'HIGH()', 'TOP()'],
        'correctAnswer': 'MAX()',
        'explanation': 'MAX() returns the highest value in a specified column.',
        'selectedAnswer': null,
        'displayNumber': 23
      },
      {
        'questionText': 'Which SQL keyword sorts query results in ascending order?',
        'options': ['ASC', 'SORT', 'ORDER', 'GROUP'],
        'correctAnswer': 'ASC',
        'explanation': 'ASC is used with ORDER BY to sort results in ascending order.',
        'selectedAnswer': null,
        'displayNumber': 24
      },
      {
        'questionText': 'Which SQL command removes a row from a table?',
        'options': ['DELETE', 'REMOVE', 'DROP', 'ERASE'],
        'correctAnswer': 'DELETE',
        'explanation': 'DELETE removes specific rows from a table based on a condition.',
        'selectedAnswer': null,
        'displayNumber': 25
      },
      {
        'questionText': 'Which SQL clause is used to group records that have the same values?',
        'options': ['ORDER BY', 'GROUP BY', 'HAVING', 'UNION'],
        'correctAnswer': 'GROUP BY',
        'explanation': 'GROUP BY groups rows with identical values into summary rows.',
        'selectedAnswer': null,
        'displayNumber': 26
      },
      {
        'questionText': 'Which SQL function counts the number of rows in a table?',
        'options': ['SUM()', 'COUNT()', 'NUMBER()', 'TOTAL()'],
        'correctAnswer': 'COUNT()',
        'explanation': 'COUNT() returns the number of rows in a table or result set.',
        'selectedAnswer': null,
        'displayNumber': 27
      },
      {
        'questionText': 'Which SQL command updates data in a table?',
        'options': ['MODIFY', 'CHANGE', 'UPDATE', 'ALTER'],
        'correctAnswer': 'UPDATE',
        'explanation': 'UPDATE modifies existing data in a table.',
        'selectedAnswer': null,
        'displayNumber': 28
      },
      {
        'questionText': 'Which SQL statement is used to combine rows from two or more tables?',
        'options': ['COMBINE', 'JOIN', 'UNION', 'INTERSECT'],
        'correctAnswer': 'JOIN',
        'explanation': 'JOIN combines rows from multiple tables based on a related column.',
        'selectedAnswer': null,
        'displayNumber': 29
      },
      {
        'questionText': 'Which SQL statement is used to delete all records from a table without removing its structure?',
        'options': ['DELETE', 'TRUNCATE', 'DROP', 'ERASE'],
        'correctAnswer': 'TRUNCATE',
        'explanation': 'TRUNCATE removes all records but retains the table structure.',
        'selectedAnswer': null,
        'displayNumber': 30
      },
      {
        'questionText': 'Which SQL command is used to create a new table?',
        'options': ['CREATE', 'INSERT', 'ADD', 'MAKE'],
        'correctAnswer': 'CREATE',
        'explanation': 'CREATE is used to define and create a new table in a database.',
        'selectedAnswer': null,
        'displayNumber': 31
      },
      {
        'questionText': 'Which of the following is a Data Definition Language (DDL) command?',
        'options': ['SELECT', 'DELETE', 'ALTER', 'UPDATE'],
        'correctAnswer': 'ALTER',
        'explanation': 'ALTER is a DDL command used to modify database structures.',
        'selectedAnswer': null,
        'displayNumber': 32
      },
      {
        'questionText': 'Which SQL command is used to delete an entire table from a database?',
        'options': ['DELETE', 'DROP', 'TRUNCATE', 'REMOVE'],
        'correctAnswer': 'DROP',
        'explanation': 'DROP removes an entire table, including its structure, from the database.',
        'selectedAnswer': null,
        'displayNumber': 33
      },
      {
        'questionText': 'Which SQL clause is used to set a condition on a GROUP BY clause?',
        'options': ['WHERE', 'HAVING', 'ORDER BY', 'EXISTS'],
        'correctAnswer': 'HAVING',
        'explanation': 'HAVING filters groups created by GROUP BY based on a condition.',
        'selectedAnswer': null,
        'displayNumber': 34
      },
      {
        'questionText': 'Which of the following statements about indexes in a database is TRUE?',
        'options': ['Indexes slow down query execution', 'Indexes improve data retrieval speed', 'Indexes are used to delete data', 'Indexes duplicate data unnecessarily'],
        'correctAnswer': 'Indexes improve data retrieval speed',
        'explanation': 'Indexes enhance query performance by speeding up data retrieval.',
        'selectedAnswer': null,
        'displayNumber': 35
      },
      {
        'questionText': 'Which SQL command is used to add a new column to an existing table?',
        'options': ['MODIFY TABLE', 'ALTER TABLE', 'UPDATE TABLE', 'INSERT TABLE'],
        'correctAnswer': 'ALTER TABLE',
        'explanation': 'ALTER TABLE adds, modifies, or drops columns in an existing table.',
        'selectedAnswer': null,
        'displayNumber': 36
      },
      {
        'questionText': 'Which type of index stores pointers to actual data rows?',
        'options': ['Clustered Index', 'Non-clustered Index', 'Composite Index', 'Unique Index'],
        'correctAnswer': 'Clustered Index',
        'explanation': 'A clustered index determines the physical order of data rows and stores pointers to them.',
        'selectedAnswer': null,
        'displayNumber': 37
      },
      {
        'questionText': 'Which SQL constraint ensures that a column contains only unique values?',
        'options': ['PRIMARY KEY', 'FOREIGN KEY', 'NOT NULL', 'CHECK'],
        'correctAnswer': 'PRIMARY KEY',
        'explanation': 'A PRIMARY KEY constraint ensures uniqueness and non-null values in a column.',
        'selectedAnswer': null,
        'displayNumber': 38
      },
      {
        'questionText': 'Which type of database key allows duplicate values?',
        'options': ['Primary Key', 'Foreign Key', 'Unique Key', 'Candidate Key'],
        'correctAnswer': 'Foreign Key',
        'explanation': 'Foreign Keys can contain duplicate values as they reference another table’s primary key.',
        'selectedAnswer': null,
        'displayNumber': 39
      },
      {
        'questionText': 'Which of the following SQL operations automatically deletes related records in child tables when the parent record is deleted?',
        'options': ['ON UPDATE CASCADE', 'ON DELETE CASCADE', 'ON MODIFY CASCADE', 'ON REMOVE CASCADE'],
        'correctAnswer': 'ON DELETE CASCADE',
        'explanation': 'ON DELETE CASCADE ensures that child records are deleted when the parent record is removed.',
        'selectedAnswer': null,
        'displayNumber': 40
      },
      {
        'questionText': 'Which normal form ensures that all non-key attributes are fully dependent on the primary key?',
        'options': ['1NF', '2NF', '3NF', 'BCNF'],
        'correctAnswer': '2NF',
        'explanation': '2NF requires full functional dependency of non-key attributes on the primary key.',
        'selectedAnswer': null,
        'displayNumber': 41
      },
      {
        'questionText': 'Which normal form eliminates transitive dependencies?',
        'options': ['1NF', '2NF', '3NF', '4NF'],
        'correctAnswer': '3NF',
        'explanation': '3NF removes transitive dependencies between non-key attributes.',
        'selectedAnswer': null,
        'displayNumber': 42
      },
      {
        'questionText': 'Which of the following is NOT a property of a database transaction?',
        'options': ['Atomicity', 'Consistency', 'Redundancy', 'Durability'],
        'correctAnswer': 'Redundancy',
        'explanation': 'Redundancy is not an ACID property; the correct properties are Atomicity, Consistency, Isolation, and Durability.',
        'selectedAnswer': null,
        'displayNumber': 43
      },
      {
        'questionText': 'Which ACID property ensures that changes made by a committed transaction are permanent?',
        'options': ['Atomicity', 'Consistency', 'Durability', 'Isolation'],
        'correctAnswer': 'Durability',
        'explanation': 'Durability ensures that committed transaction changes are permanently saved.',
        'selectedAnswer': null,
        'displayNumber': 44
      },
      {
        'questionText': 'Which of the following is NOT a type of database anomaly?',
        'options': ['Insertion Anomaly', 'Deletion Anomaly', 'Modification Anomaly', 'Update Anomaly'],
        'correctAnswer': 'Modification Anomaly',
        'explanation': 'Modification Anomaly is not a standard term; the common anomalies are Insertion, Deletion, and Update.',
        'selectedAnswer': null,
        'displayNumber': 45
      },
      {
        'questionText': 'Which of the following is used to ensure that transactions are executed in a controlled manner to maintain database consistency?',
        'options': ['Concurrency Control', 'Locking Mechanism', 'Normalization', 'Redundancy Control'],
        'correctAnswer': 'Concurrency Control',
        'explanation': 'Concurrency Control manages simultaneous transactions to maintain consistency.',
        'selectedAnswer': null,
        'displayNumber': 46
      },
      {
        'questionText': 'Which of the following is a concurrency control technique?',
        'options': ['Deadlock', 'Two-Phase Locking (2PL)', 'Data Redundancy', 'Denormalization'],
        'correctAnswer': 'Two-Phase Locking (2PL)',
        'explanation': 'Two-Phase Locking (2PL) is a technique to ensure serializability in concurrent transactions.',
        'selectedAnswer': null,
        'displayNumber': 47
      },
      {
        'questionText': 'Which of the following problems occurs when multiple transactions read and write the same data concurrently?',
        'options': ['Lost Update', 'Deadlock', 'Serializability', 'Rollback'],
        'correctAnswer': 'Lost Update',
        'explanation': 'Lost Update occurs when one transaction’s update is overwritten by another due to concurrent access.',
        'selectedAnswer': null,
        'displayNumber': 48
      },
      {
        'questionText': 'Which schedule ensures that the final database state is the same as if transactions were executed sequentially?',
        'options': ['Serializable Schedule', 'Non-Serializable Schedule', 'Concurrency Schedule', 'Parallel Schedule'],
        'correctAnswer': 'Serializable Schedule',
        'explanation': 'A Serializable Schedule ensures the outcome matches sequential execution.',
        'selectedAnswer': null,
        'displayNumber': 49
      },
      {
        'questionText': 'Which of the following occurs when two or more transactions wait for each other to release a lock on resources?',
        'options': ['Dirty Read', 'Deadlock', 'Lost Update', 'Phantom Read'],
        'correctAnswer': 'Deadlock',
        'explanation': 'Deadlock occurs when transactions wait indefinitely for each other to release locks.',
        'selectedAnswer': null,
        'displayNumber': 50
      }
    ],
    'DS': [
      // Module 1: Introduction to Data Structures
      {
        'questionText': 'Which of the following is a linear data structure?',
        'options': ['Graph', 'Tree', 'Stack', 'Heap'],
        'correctAnswer': 'Stack',
        'explanation': 'A stack is a linear data structure where elements are arranged sequentially.',
        'selectedAnswer': null,
        'displayNumber': 1
      },
      {
        'questionText': 'Which of the following follows the FIFO principle?',
        'options': ['Stack', 'Queue', 'Heap', 'Graph'],
        'correctAnswer': 'Queue',
        'explanation': 'A queue follows First In, First Out (FIFO) principle.',
        'selectedAnswer': null,
        'displayNumber': 2
      },
      {
        'questionText': 'The best data structure to implement a priority queue is:',
        'options': ['Stack', 'Heap', 'Array', 'Queue'],
        'correctAnswer': 'Heap',
        'explanation': 'A heap is ideal for priority queues due to its efficient priority-based ordering.',
        'selectedAnswer': null,
        'displayNumber': 3
      },
      {
        'questionText': 'Which data structure allows insertion and deletion at both ends?',
        'options': ['Stack', 'Queue', 'Deque', 'Heap'],
        'correctAnswer': 'Deque',
        'explanation': 'A deque (double-ended queue) supports operations at both ends.',
        'selectedAnswer': null,
        'displayNumber': 4
      },
      {
        'questionText': 'Which data structure is used for recursion?',
        'options': ['Queue', 'Stack', 'Linked List', 'Tree'],
        'correctAnswer': 'Stack',
        'explanation': 'Recursion uses a stack to manage function calls.',
        'selectedAnswer': null,
        'displayNumber': 5
      },
      {
        'questionText': 'What is the worst-case time complexity of searching an element in an unsorted array?',
        'options': ['O(1)', 'O(n)', 'O(log n)', 'O(n log n)'],
        'correctAnswer': 'O(n)',
        'explanation': 'Searching an unsorted array requires checking each element in the worst case.',
        'selectedAnswer': null,
        'displayNumber': 6
      },
      {
        'questionText': 'Which of the following is a non-linear data structure?',
        'options': ['Array', 'Stack', 'Graph', 'Queue'],
        'correctAnswer': 'Graph',
        'explanation': 'Graphs have a non-linear structure with nodes connected in various ways.',
        'selectedAnswer': null,
        'displayNumber': 7
      },
      {
        'questionText': 'Which data structure is used for implementing undo and redo functionality?',
        'options': ['Queue', 'Stack', 'Linked List', 'Tree'],
        'correctAnswer': 'Stack',
        'explanation': 'Stacks are used for undo/redo as they track operations in LIFO order.',
        'selectedAnswer': null,
        'displayNumber': 8
      },
      {
        'questionText': 'Which data structure allows constant-time access to its elements?',
        'options': ['Array', 'Stack', 'Linked List', 'Graph'],
        'correctAnswer': 'Array',
        'explanation': 'Arrays provide O(1) access time using indices.',
        'selectedAnswer': null,
        'displayNumber': 9
      },
      {
        'questionText': 'Which data structure is best suited for evaluating expressions?',
        'options': ['Queue', 'Stack', 'Linked List', 'Graph'],
        'correctAnswer': 'Stack',
        'explanation': 'Stacks are ideal for expression evaluation using postfix notation.',
        'selectedAnswer': null,
        'displayNumber': 10
      },

      // Linked List Questions
      {
        'questionText': 'Which type of linked list allows traversal in both directions?',
        'options': ['Singly Linked List', 'Doubly Linked List', 'Circular Linked List', 'None of the above'],
        'correctAnswer': 'Doubly Linked List',
        'explanation': 'Doubly linked lists have pointers to both next and previous nodes.',
        'selectedAnswer': null,
        'displayNumber': 11
      },
      {
        'questionText': 'What is the time complexity of inserting an element at the beginning of a singly linked list?',
        'options': ['O(1)', 'O(n)', 'O(log n)', 'O(n log n)'],
        'correctAnswer': 'O(1)',
        'explanation': 'Insertion at the head of a singly linked list takes constant time.',
        'selectedAnswer': null,
        'displayNumber': 12
      },
      {
        'questionText': 'Which of the following statements is true about linked lists?',
        'options': ['They use contiguous memory locations', 'They have dynamic memory allocation', 'They allow constant-time access to elements', 'None of the above'],
        'correctAnswer': 'They have dynamic memory allocation',
        'explanation': 'Linked lists use non-contiguous, dynamically allocated memory.',
        'selectedAnswer': null,
        'displayNumber': 13
      },
      {
        'questionText': 'Which of the following is an advantage of using a linked list over an array?',
        'options': ['Faster random access', 'Better cache locality', 'Efficient insertion and deletion', 'Requires less memory'],
        'correctAnswer': 'Efficient insertion and deletion',
        'explanation': 'Linked lists excel at insertion/deletion due to pointer adjustments.',
        'selectedAnswer': null,
        'displayNumber': 14
      },
      {
        'questionText': 'What is the worst-case time complexity for searching an element in an unsorted singly linked list?',
        'options': ['O(1)', 'O(log n)', 'O(n)', 'O(n log n)'],
        'correctAnswer': 'O(n)',
        'explanation': 'Searching requires traversing the entire list in the worst case.',
        'selectedAnswer': null,
        'displayNumber': 15
      },
      {
        'questionText': 'Which of the following operations is more efficient in a linked list than in an array?',
        'options': ['Accessing an element', 'Searching for an element', 'Inserting an element at the beginning', 'Sorting the elements'],
        'correctAnswer': 'Inserting an element at the beginning',
        'explanation': 'Inserting at the head is O(1) in linked lists, O(n) in arrays.',
        'selectedAnswer': null,
        'displayNumber': 16
      },
      {
        'questionText': 'In a circular linked list, where does the last node point to?',
        'options': ['Null', 'Head node', 'Random node', 'Previous node'],
        'correctAnswer': 'Head node',
        'explanation': 'In a circular linked list, the last node points back to the head.',
        'selectedAnswer': null,
        'displayNumber': 17
      },
      {
        'questionText': 'Which of the following applications uses a linked list?',
        'options': ['Undo/Redo operations', 'Call stack of a recursive function', 'Hash Table with chaining', 'All of the above'],
        'correctAnswer': 'All of the above',
        'explanation': 'Linked lists are versatile and used in all these applications.',
        'selectedAnswer': null,
        'displayNumber': 18
      },
      {
        'questionText': 'Which type of linked list requires extra space for storing two pointers per node?',
        'options': ['Singly Linked List', 'Doubly Linked List', 'Circular Linked List', 'None of the above'],
        'correctAnswer': 'Doubly Linked List',
        'explanation': 'Doubly linked lists need space for next and previous pointers.',
        'selectedAnswer': null,
        'displayNumber': 19
      },
      {
        'questionText': 'What is the minimum number of nodes required in a circular linked list?',
        'options': ['0', '1', '2', '3'],
        'correctAnswer': '1',
        'explanation': 'A single node can form a circular linked list by pointing to itself.',
        'selectedAnswer': null,
        'displayNumber': 20
      },

      // Stack and Queue Questions
      {
        'questionText': 'Which data structure follows the Last In, First Out (LIFO) principle?',
        'options': ['Queue', 'Stack', 'Deque', 'Linked List'],
        'correctAnswer': 'Stack',
        'explanation': 'Stacks operate on the LIFO principle.',
        'selectedAnswer': null,
        'displayNumber': 21
      },
      {
        'questionText': 'Which of the following operations is not possible in a queue?',
        'options': ['Insertion at the front', 'Insertion at the rear', 'Deletion from the front', 'Traversing all elements'],
        'correctAnswer': 'Insertion at the front',
        'explanation': 'Standard queues only allow insertion at the rear.',
        'selectedAnswer': null,
        'displayNumber': 22
      },
      {
        'questionText': 'Which of the following is a real-world example of a stack?',
        'options': ['People standing in a queue', 'A pile of plates in a cafeteria', 'A printer’s job queue', 'Ticket reservation system'],
        'correctAnswer': 'A pile of plates in a cafeteria',
        'explanation': 'Plates are removed from the top, following LIFO.',
        'selectedAnswer': null,
        'displayNumber': 23
      },
      {
        'questionText': 'Which data structure is used for function call management in recursion?',
        'options': ['Queue', 'Stack', 'Heap', 'Graph'],
        'correctAnswer': 'Stack',
        'explanation': 'The call stack manages recursive function calls.',
        'selectedAnswer': null,
        'displayNumber': 24
      },
      {
        'questionText': 'What is the time complexity of the push operation in a stack implemented using an array?',
        'options': ['O(1)', 'O(n)', 'O(log n)', 'O(n log n)'],
        'correctAnswer': 'O(1)',
        'explanation': 'Pushing onto an array-based stack is constant time, assuming space is available.',
        'selectedAnswer': null,
        'displayNumber': 25
      },
      {
        'questionText': 'Which type of queue allows insertion and deletion at both ends?',
        'options': ['Circular Queue', 'Deque', 'Priority Queue', 'Simple Queue'],
        'correctAnswer': 'Deque',
        'explanation': 'A deque supports operations at both ends.',
        'selectedAnswer': null,
        'displayNumber': 26
      },
      {
        'questionText': 'A circular queue helps in preventing which of the following problems?',
        'options': ['Overflow', 'Underflow', 'Memory wastage', 'Sorting'],
        'correctAnswer': 'Memory wastage',
        'explanation': 'Circular queues reuse space efficiently.',
        'selectedAnswer': null,
        'displayNumber': 27
      },
      {
        'questionText': 'What happens when an element is inserted into a full queue?',
        'options': ['Overflow', 'Underflow', 'The element is inserted at the front', 'The queue resets itself'],
        'correctAnswer': 'Overflow',
        'explanation': 'Inserting into a full queue causes an overflow condition.',
        'selectedAnswer': null,
        'displayNumber': 28
      },
      {
        'questionText': 'In a circular queue with a size of N, what is the formula to check if the queue is full?',
        'options': ['(rear + 1) % N == front', 'front == rear', 'rear == N', 'front == -1'],
        'correctAnswer': '(rear + 1) % N == front',
        'explanation': 'This formula checks if the next insertion position equals the front.',
        'selectedAnswer': null,
        'displayNumber': 29
      },
      {
        'questionText': 'Which of the following applications use a queue?',
        'options': ['CPU scheduling', 'Printer spooler', 'Breadth-First Search (BFS)', 'All of the above'],
        'correctAnswer': 'All of the above',
        'explanation': 'Queues are widely used in these applications for FIFO processing.',
        'selectedAnswer': null,
        'displayNumber': 30
      },

      // Module 4: Trees and Graphs
      {
        'questionText': 'What is the maximum number of children a node can have in a binary tree?',
        'options': ['1', '2', '3', 'Any number'],
        'correctAnswer': '2',
        'explanation': 'A binary tree node can have at most two children.',
        'selectedAnswer': null,
        'displayNumber': 31
      },
      {
        'questionText': 'What is the height of a complete binary tree with n nodes?',
        'options': ['O(n)', 'O(log n)', 'O(n log n)', 'O(1)'],
        'correctAnswer': 'O(log n)',
        'explanation': 'The height of a complete binary tree is logarithmic in the number of nodes.',
        'selectedAnswer': null,
        'displayNumber': 32
      },
      {
        'questionText': 'Which of the following is true about a binary search tree (BST)?',
        'options': ['The left subtree contains values greater than the root', 'The right subtree contains values smaller than the root', 'The left subtree contains values smaller than the root', 'The tree is always complete'],
        'correctAnswer': 'The left subtree contains values smaller than the root',
        'explanation': 'In a BST, left subtree values are less than the root.',
        'selectedAnswer': null,
        'displayNumber': 33
      },
      {
        'questionText': 'Which of the following tree traversal methods visits nodes in the order: Left-Root-Right?',
        'options': ['Preorder', 'Inorder', 'Postorder', 'Level order'],
        'correctAnswer': 'Inorder',
        'explanation': 'Inorder traversal follows Left-Root-Right order.',
        'selectedAnswer': null,
        'displayNumber': 34
      },
      {
        'questionText': 'Which of the following graph traversal algorithms uses a queue?',
        'options': ['Depth-First Search (DFS)', 'Breadth-First Search (BFS)', 'Dijkstra’s Algorithm', 'Kruskal’s Algorithm'],
        'correctAnswer': 'Breadth-First Search (BFS)',
        'explanation': 'BFS uses a queue to explore nodes level by level.',
        'selectedAnswer': null,
        'displayNumber': 35
      },
      {
        'questionText': 'What is the time complexity of searching an element in a balanced binary search tree (BST)?',
        'options': ['O(n)', 'O(log n)', 'O(n log n)', 'O(1)'],
        'correctAnswer': 'O(log n)',
        'explanation': 'Balanced BSTs allow logarithmic time search.',
        'selectedAnswer': null,
        'displayNumber': 36
      },
      {
        'questionText': 'Which algorithm is used to find the shortest path in a weighted graph?',
        'options': ['Prim’s Algorithm', 'Dijkstra’s Algorithm', 'Kruskal’s Algorithm', 'Depth-First Search (DFS)'],
        'correctAnswer': 'Dijkstra’s Algorithm',
        'explanation': 'Dijkstra’s algorithm finds the shortest path in weighted graphs.',
        'selectedAnswer': null,
        'displayNumber': 37
      },
      {
        'questionText': 'A tree with n nodes always has how many edges?',
        'options': ['n+1', 'n-1', '2n', 'log n'],
        'correctAnswer': 'n-1',
        'explanation': 'A tree with n nodes has exactly n-1 edges.',
        'selectedAnswer': null,
        'displayNumber': 38
      },
      {
        'questionText': 'Which data structure is used to implement Depth-First Search (DFS) in graphs?',
        'options': ['Queue', 'Stack', 'Priority Queue', 'Linked List'],
        'correctAnswer': 'Stack',
        'explanation': 'DFS uses a stack (often implicitly via recursion).',
        'selectedAnswer': null,
        'displayNumber': 39
      },
      {
        'questionText': 'Which of the following trees is always balanced?',
        'options': ['Binary Search Tree', 'AVL Tree', 'Binary Tree', 'General Tree'],
        'correctAnswer': 'AVL Tree',
        'explanation': 'AVL trees maintain balance through rotations.',
        'selectedAnswer': null,
        'displayNumber': 40
      },

      // Module 5: Sorting and Searching
      {
        'questionText': 'Which of the following sorting algorithms has the best average-case time complexity?',
        'options': ['Bubble Sort', 'Quick Sort', 'Merge Sort', 'Selection Sort'],
        'correctAnswer': 'Merge Sort',
        'explanation': 'Merge Sort has an average-case time complexity of O(n log n), which is optimal.',
        'selectedAnswer': null,
        'displayNumber': 41
      },
      {
        'questionText': 'What is the time complexity of binary search in a sorted array?',
        'options': ['O(n)', 'O(log n)', 'O(n log n)', 'O(1)'],
        'correctAnswer': 'O(log n)',
        'explanation': 'Binary search divides the search space in half each step.',
        'selectedAnswer': null,
        'displayNumber': 42
      },
      {
        'questionText': 'Which sorting algorithm works by repeatedly swapping adjacent elements if they are in the wrong order?',
        'options': ['Merge Sort', 'Quick Sort', 'Bubble Sort', 'Heap Sort'],
        'correctAnswer': 'Bubble Sort',
        'explanation': 'Bubble Sort compares and swaps adjacent elements.',
        'selectedAnswer': null,
        'displayNumber': 43
      },
      {
        'questionText': 'Which of the following sorting algorithms follows the divide-and-conquer approach?',
        'options': ['Quick Sort', 'Bubble Sort', 'Selection Sort', 'Insertion Sort'],
        'correctAnswer': 'Quick Sort',
        'explanation': 'Quick Sort partitions the array and recursively sorts subarrays.',
        'selectedAnswer': null,
        'displayNumber': 44
      },
      {
        'questionText': 'What is the worst-case time complexity of Quick Sort?',
        'options': ['O(n)', 'O(n log n)', 'O(n²)', 'O(log n)'],
        'correctAnswer': 'O(n²)',
        'explanation': 'Quick Sort’s worst case occurs with already sorted or reverse sorted arrays.',
        'selectedAnswer': null,
        'displayNumber': 45
      },
      {
        'questionText': 'Which searching algorithm does not require the list to be sorted?',
        'options': ['Linear Search', 'Binary Search', 'Interpolation Search', 'Fibonacci Search'],
        'correctAnswer': 'Linear Search',
        'explanation': 'Linear Search works on unsorted data by checking each element.',
        'selectedAnswer': null,
        'displayNumber': 46
      },
      {
        'questionText': 'Which sorting algorithm is best for nearly sorted data?',
        'options': ['Bubble Sort', 'Insertion Sort', 'Merge Sort', 'Quick Sort'],
        'correctAnswer': 'Insertion Sort',
        'explanation': 'Insertion Sort performs well on nearly sorted data with O(n) in the best case.',
        'selectedAnswer': null,
        'displayNumber': 47
      },
      {
        'questionText': 'Which of the following sorting algorithms has a worst-case time complexity of O(n log n)?',
        'options': ['Merge Sort', 'Quick Sort', 'Heap Sort', 'All of the above'],
        'correctAnswer': 'All of the above',
        'explanation': 'All listed algorithms achieve O(n log n) in their worst case.',
        'selectedAnswer': null,
        'displayNumber': 48
      },
      {
        'questionText': 'Which sorting algorithm is the most efficient for sorting large datasets?',
        'options': ['Selection Sort', 'Bubble Sort', 'Merge Sort', 'Insertion Sort'],
        'correctAnswer': 'Merge Sort',
        'explanation': 'Merge Sort’s O(n log n) complexity makes it efficient for large datasets.',
        'selectedAnswer': null,
        'displayNumber': 49
      },
      {
        'questionText': 'Which search algorithm finds the position of an element by estimating its probable location?',
        'options': ['Binary Search', 'Linear Search', 'Interpolation Search', 'Fibonacci Search'],
        'correctAnswer': 'Interpolation Search',
        'explanation': 'Interpolation Search estimates the position based on value distribution.',
        'selectedAnswer': null,
        'displayNumber': 50
      }
    ],
    'OS': [
      {
        'questionText': 'The part of machine level instruction, which tells the central processor what has to be done, is',
        'options': ['Operation code', 'Address', 'Locator', 'Flip-Flop', 'None of the above'],
        'correctAnswer': 'Operation code',
        'explanation': 'The operation code (opcode) specifies the operation (e.g., ADD, MOV) to be performed by the CPU.',
        'selectedAnswer': null,
        'displayNumber': 1
      },
      {
        'questionText': 'Which of the following refers to the associative memory?',
        'options': ['The address of the data is generated by the CPU', 'The address of the data is supplied by the users', 'There is no need for an address i.e. the data is used as an address', 'The data are accessed sequentially', 'None of the above'],
        'correctAnswer': 'There is no need for an address i.e. the data is used as an address',
        'explanation': 'Associative memory (content-addressable memory) uses data content as the address for retrieval.',
        'selectedAnswer': null,
        'displayNumber': 2
      },
      {
        'questionText': 'To avoid the race condition, the number of processes that may be simultaneously inside their critical section is',
        'options': ['8', '1', '16', '0', 'None of the above'],
        'correctAnswer': '1',
        'explanation': 'To prevent race conditions, only one process can be in its critical section at a time.',
        'selectedAnswer': null,
        'displayNumber': 3
      },
      {
        'questionText': 'A system program that combines the separately compiled modules of a program into a form suitable for execution',
        'options': ['Assembler', 'Linking loader', 'Cross compiler', 'Load and go', 'None of the above'],
        'correctAnswer': 'Linking loader',
        'explanation': 'A linking loader combines object modules and resolves references for execution.',
        'selectedAnswer': null,
        'displayNumber': 4
      },
      {
        'questionText': 'Process is',
        'options': ['Program in High level language kept on disk', 'Contents of main memory', 'A program in execution', 'A job in secondary memory', 'None of the above'],
        'correctAnswer': 'A program in execution',
        'explanation': 'A process is an active program being executed by the CPU.',
        'selectedAnswer': null,
        'displayNumber': 5
      },
      {
        'questionText': 'The initial value of the semaphore that allows only one of the many processes to enter their critical sections, is',
        'options': ['8', '1', '16', '0', 'None of the above'],
        'correctAnswer': '1',
        'explanation': 'A semaphore initialized to 1 ensures mutual exclusion by allowing only one process in the critical section.',
        'selectedAnswer': null,
        'displayNumber': 6
      },
      {
        'questionText': 'A page fault',
        'options': ['Is an error in a specific page', 'Occurs when a program accesses a page of memory', 'Is an access to a page not currently in memory', 'Is a reference to a page belonging to another program', 'None of the above'],
        'correctAnswer': 'Is an access to a page not currently in memory',
        'explanation': 'A page fault occurs when a requested page is not in main memory, triggering a fetch from secondary storage.',
        'selectedAnswer': null,
        'displayNumber': 7
      },
      {
        'questionText': 'The process of transferring data intended for a peripheral device into a disk (or intermediate store) so that it can be transferred to peripheral at a more convenient time or in bulk, is known as',
        'options': ['Multiprogramming', 'Spooling', 'Caching', 'Virtual programming', 'None of the above'],
        'correctAnswer': 'Spooling',
        'explanation': 'Spooling buffers data for peripherals (e.g., printers) to improve efficiency.',
        'selectedAnswer': null,
        'displayNumber': 8
      },
      {
        'questionText': 'In which of the storage placement strategies a program is placed in the largest available hole in the main memory?',
        'options': ['Best fit', 'First fit', 'Worst fit', 'Buddy', 'None of the above'],
        'correctAnswer': 'Worst fit',
        'explanation': 'Worst fit places a program in the largest available memory hole to minimize fragmentation.',
        'selectedAnswer': null,
        'displayNumber': 9
      },
      {
        'questionText': 'Which of the following is a block device',
        'options': ['Mouse', 'Printer', 'Terminals', 'Disk', 'None of the above'],
        'correctAnswer': 'Disk',
        'explanation': 'A disk is a block device, handling data in fixed-size blocks, unlike character devices like mice or printers.',
        'selectedAnswer': null,
        'displayNumber': 10
      },
      {
        'questionText': 'The problem of thrashing is affected significantly by:',
        'options': ['Program structure', 'Program size', 'Primary-storage size', 'All of the above', 'None of the above'],
        'correctAnswer': 'All of the above',
        'explanation': 'Thrashing depends on how a program accesses memory, its size, and the available primary storage.',
        'selectedAnswer': null,
        'displayNumber': 11
      },
      {
        'questionText': 'Which of the following software types is used to simplify using systems software?',
        'options': ['Spreadsheet', 'Operating environment', 'Timesharing', 'Multitasking', 'None of the above'],
        'correctAnswer': 'Operating environment',
        'explanation': 'An operating environment (e.g., GUI shells) simplifies interaction with system software.',
        'selectedAnswer': null,
        'displayNumber': 12
      },
      {
        'questionText': 'Advantage(s) of using assembly language rather than machine language is (are):',
        'options': ['It is mnemonic and easy to read.', 'Addresses any symbolic, not absolute', 'Introduction of data to program is easier', 'All of the above', 'None of the above'],
        'correctAnswer': 'All of the above',
        'explanation': 'Assembly language uses mnemonics, symbolic addresses, and simplifies data handling compared to machine language.',
        'selectedAnswer': null,
        'displayNumber': 13
      },
      {
        'questionText': 'Capacity planning',
        'options': ['Requires detailed system performance information', 'Is independent of the operating system', 'Does not depend on the monitoring tools available', 'Is not needed in small installations', 'None of the above'],
        'correctAnswer': 'Requires detailed system performance information',
        'explanation': 'Capacity planning relies on performance data to predict resource needs.',
        'selectedAnswer': null,
        'displayNumber': 14
      },
      {
        'questionText': 'Poor response times are caused by',
        'options': ['Processor busy', 'High I/O rate', 'High paging rates', 'Any of the above', 'None of the above'],
        'correctAnswer': 'Any of the above',
        'explanation': 'Busy processors, high I/O rates, or excessive paging can all degrade response times.',
        'selectedAnswer': null,
        'displayNumber': 15
      },
      {
        'questionText': 'Link encryption',
        'options': ['Is more secure than end-to-end encryption', 'Is less secure than end-to-end encryption', 'Can not be used in a public network', 'Is used only to debug', 'None of the above'],
        'correctAnswer': 'Is less secure than end-to-end encryption',
        'explanation': 'Link encryption secures data only between nodes, while end-to-end encryption protects the entire path.',
        'selectedAnswer': null,
        'displayNumber': 16
      },
      {
        'questionText': 'A form of code that uses more than one process and processor, possibly of different type, and that may on occasions have more than one process or processor active at the same time, is known as',
        'options': ['Multiprogramming', 'Multi threading', 'Broadcasting', 'Time sharing', 'None of the above'],
        'correctAnswer': 'None of the above',
        'explanation': 'The description fits parallel processing or multiprocessing, not listed among the options.',
        'selectedAnswer': null,
        'displayNumber': 17
      },
      {
        'questionText': 'The table created by lexical analysis to describe all literals used in the source program, is',
        'options': ['Terminal table', 'Literal table', 'Identifier table', 'Reductions', 'None of the above'],
        'correctAnswer': 'Literal table',
        'explanation': 'The literal table stores all literals (e.g., constants) encountered during lexical analysis.',
        'selectedAnswer': null,
        'displayNumber': 18
      },
      {
        'questionText': 'An instruction in a programming language that is replaced by a sequence of instructions prior to assembly or compiling is known as',
        'options': ['Procedure name', 'Macro', 'Label', 'Literal', 'None of the above'],
        'correctAnswer': 'Macro',
        'explanation': 'A macro is a shorthand that expands into a sequence of instructions during preprocessing.',
        'selectedAnswer': null,
        'displayNumber': 19
      },
      {
        'questionText': 'A self-relocating program is one which',
        'options': ['Cannot be made to execute in any area of storage other than the one designated for it at the time of its coding or translation.', 'Consists of a program and relevant information for its relocation.', 'Can itself perform the relocation of its address-sensitive portions.', 'All of the above', 'None of the above'],
        'correctAnswer': 'Can itself perform the relocation of its address-sensitive portions.',
        'explanation': 'A self-relocating program adjusts its own addresses to run in different memory locations.',
        'selectedAnswer': null,
        'displayNumber': 20
      },
      {
        'questionText': 'Banker\'s algorithm for resource allocation deals with',
        'options': ['Deadlock prevention', 'Deadlock avoidance', 'Deadlock recovery', 'Mutual exclusion', 'None of the above'],
        'correctAnswer': 'Deadlock avoidance',
        'explanation': 'Banker\'s algorithm ensures resources are allocated to avoid potential deadlocks.',
        'selectedAnswer': null,
        'displayNumber': 21
      },
      {
        'questionText': 'A Process Control Block (PCB) does not contain which of the following?',
        'options': ['Code', 'Stack', 'Bootstrap program', 'Data'],
        'correctAnswer': 'Bootstrap program',
        'explanation': 'The PCB contains process state info (e.g., stack, data) but not the bootstrap program, which initializes the system.',
        'selectedAnswer': null,
        'displayNumber': 22
      },
      {
        'questionText': 'What is a Process Control Block?',
        'options': ['Process type variable', 'Data Structure', 'A secondary storage section', 'A Block in memory'],
        'correctAnswer': 'Data Structure',
        'explanation': 'The PCB is a data structure storing process metadata (e.g., state, registers).',
        'selectedAnswer': null,
        'displayNumber': 23
      },
      {
        'questionText': 'The entry of all the PCBs of the current processes is in',
        'options': ['Process Register', 'Program Counter', 'Process Table', 'Process Unit'],
        'correctAnswer': 'Process Table',
        'explanation': 'The process table maintains PCBs for all active processes.',
        'selectedAnswer': null,
        'displayNumber': 24
      },
      {
        'questionText': 'What is the degree of multiprogramming?',
        'options': ['The number of processes executed per unit time', 'The number of processes in the ready queue', 'The number of processes in the I/O queue', 'The number of processes in memory'],
        'correctAnswer': 'The number of processes in memory',
        'explanation': 'The degree of multiprogramming is the number of processes currently loaded in memory.',
        'selectedAnswer': null,
        'displayNumber': 25
      },
      {
        'questionText': 'A single thread of control allows the process to perform',
        'options': ['Only one task at a time', 'Multiple tasks at a time', 'Only two tasks at a time', 'All of the mentioned'],
        'correctAnswer': 'Only one task at a time',
        'explanation': 'A single-threaded process executes one task sequentially.',
        'selectedAnswer': null,
        'displayNumber': 26
      },
      {
        'questionText': 'What will happen when a process terminates?',
        'options': ['It is removed from all queues', 'It is removed from all, but the job queue', 'Its process control block is de-allocated', 'Its process control block is never de-allocated'],
        'correctAnswer': 'It is removed from all queues',
        'explanation': 'Upon termination, a process is removed from all queues, and its PCB is typically de-allocated (though not listed as an option).',
        'selectedAnswer': null,
        'displayNumber': 27
      },
      {
        'questionText': 'What is a long-term scheduler?',
        'options': ['It selects which process has to be brought into the ready queue', 'It selects which process has to be executed next and allocates CPU', 'It selects which process to remove from memory by swapping', 'None of the mentioned'],
        'correctAnswer': 'It selects which process has to be brought into the ready queue',
        'explanation': 'The long-term scheduler decides which jobs enter the ready queue from the job pool.',
        'selectedAnswer': null,
        'displayNumber': 28
      },
      {
        'questionText': 'If all processes are I/O bound, the ready queue will almost always be ______ and the Short term Scheduler will have a ______ to do.',
        'options': ['Full, little', 'Full, lot', 'Empty, little', 'Empty, lot'],
        'correctAnswer': 'Empty, little',
        'explanation': 'I/O-bound processes spend most time waiting, leaving the ready queue empty and the short-term scheduler idle.',
        'selectedAnswer': null,
        'displayNumber': 29
      },
      {
        'questionText': 'What is a medium-term scheduler?',
        'options': ['It selects which process has to be brought into the ready queue', 'It selects which process has to be executed next and allocates CPU', 'It selects which process to remove from memory by swapping', 'None of the mentioned'],
        'correctAnswer': 'It selects which process to remove from memory by swapping',
        'explanation': 'The medium-term scheduler manages swapping processes in and out of memory.',
        'selectedAnswer': null,
        'displayNumber': 30
      },
      {
        'questionText': 'What is a short-term scheduler?',
        'options': ['It selects which process has to be brought into the ready queue', 'It selects which process has to be executed next and allocates CPU', 'It selects which process to remove from memory by swapping', 'None of the mentioned'],
        'correctAnswer': 'It selects which process has to be executed next and allocates CPU',
        'explanation': 'The short-term scheduler (CPU scheduler) assigns CPU time to ready processes.',
        'selectedAnswer': null,
        'displayNumber': 31
      },
      {
        'questionText': 'The primary distinction between the short-term scheduler and the long-term scheduler is',
        'options': ['The length of their queues', 'The type of processes they schedule', 'The frequency of their execution', 'None of the mentioned'],
        'correctAnswer': 'The frequency of their execution',
        'explanation': 'Short-term schedulers run frequently (e.g., every time slice), while long-term schedulers run less often.',
        'selectedAnswer': null,
        'displayNumber': 32
      },
      {
        'questionText': 'The only state transition that is initiated by the user process itself is',
        'options': ['Block', 'Wakeup', 'Dispatch', 'None of the mentioned'],
        'correctAnswer': 'Block',
        'explanation': 'A process blocks itself when it requests I/O or waits for an event.',
        'selectedAnswer': null,
        'displayNumber': 33
      },
      {
        'questionText': 'In a time-sharing operating system, when the time slot given to a process is completed, the process goes from the running state to the',
        'options': ['Blocked state', 'Ready state', 'Suspended state', 'Terminated state'],
        'correctAnswer': 'Ready state',
        'explanation': 'After its time slice, a process returns to the ready queue to await another turn.',
        'selectedAnswer': null,
        'displayNumber': 34
      },
      {
        'questionText': 'In a multiprogramming environment',
        'options': ['The processor executes more than one process at a time', 'The programs are developed by more than one person', 'More than one process resides in the memory', 'A single user can execute many programs at the same time'],
        'correctAnswer': 'More than one process resides in the memory',
        'explanation': 'Multiprogramming keeps multiple processes in memory, allowing CPU switching between them.',
        'selectedAnswer': null,
        'displayNumber': 35
      },
      {
        'questionText': 'Suppose that a process is in “Blocked” state waiting for some I/O service. When the service is completed, it goes to the',
        'options': ['Running state', 'Ready state', 'Suspended state', 'Terminated state'],
        'correctAnswer': 'Ready state',
        'explanation': 'After I/O completion, the process moves to the ready state, awaiting CPU allocation.',
        'selectedAnswer': null,
        'displayNumber': 36
      },
      {
        'questionText': 'The context of a process in the PCB of a process does not contain',
        'options': ['The value of the CPU registers', 'The process state', 'Memory-management information', 'Context switch time'],
        'correctAnswer': 'Context switch time',
        'explanation': 'The PCB stores register values, state, and memory info, but not the time taken for context switching.',
        'selectedAnswer': null,
        'displayNumber': 37
      },
      {
        'questionText': 'Which of the following need not necessarily be saved on a context switch between processes?',
        'options': ['General purpose registers', 'Translation lookaside buffer', 'Program counter', 'All of the mentioned'],
        'correctAnswer': 'Translation lookaside buffer',
        'explanation': 'The TLB can be cleared or reloaded rather than saved, unlike registers and the program counter.',
        'selectedAnswer': null,
        'displayNumber': 38
      },
      {
        'questionText': 'Which of the following does not interrupt a running process?',
        'options': ['A device', 'Timer', 'Scheduler process', 'Power failure'],
        'correctAnswer': 'Scheduler process',
        'explanation': 'The scheduler decides process switches but doesn’t interrupt; devices, timers, and power failures do.',
        'selectedAnswer': null,
        'displayNumber': 39
      },
      {
        'questionText': 'All processes share a semaphore variable mutex, initialized to 1. Each process must execute wait(mutex) before entering the critical section and signal(mutex) afterward. Suppose a process executes in the following manner: wait(mutex); ... critical section ... wait(mutex);',
        'options': ['A deadlock will occur', 'Processes will starve to enter critical section', 'Several processes may be executing in their critical section', 'All of the mentioned'],
        'correctAnswer': 'A deadlock will occur',
        'explanation': 'The second wait(mutex) by the same process locks it indefinitely, causing a deadlock.',
        'selectedAnswer': null,
        'displayNumber': 40
      },
      {
        'questionText': 'The dining-philosophers problem will occur in case of',
        'options': ['5 philosophers and 5 chopsticks', '4 philosophers and 5 chopsticks', '3 philosophers and 5 chopsticks', '6 philosophers and 5 chopsticks'],
        'correctAnswer': '5 philosophers and 5 chopsticks',
        'explanation': 'The classic problem requires equal numbers of philosophers and chopsticks (resources) to demonstrate deadlock.',
        'selectedAnswer': null,
        'displayNumber': 41
      },
      {
        'questionText': 'To ensure difficulties do not arise in the readers-writers problem _____ are given exclusive access to the shared object.',
        'options': ['Readers', 'Writers', 'Readers and writers', 'None of the mentioned'],
        'correctAnswer': 'Writers',
        'explanation': 'Writers need exclusive access to prevent data corruption, while readers can share access.',
        'selectedAnswer': null,
        'displayNumber': 42
      },
      {
        'questionText': 'In the bounded buffer problem, there are the empty and full semaphores that',
        'options': ['Count the number of empty and full buffers', 'Count the number of empty and full memory spaces', 'Count the number of empty and full queues', 'None of the mentioned'],
        'correctAnswer': 'Count the number of empty and full buffers',
        'explanation': 'The semaphores track available (empty) and occupied (full) slots in the buffer.',
        'selectedAnswer': null,
        'displayNumber': 43
      },
      {
        'questionText': 'The bounded buffer problem is also known as',
        'options': ['Readers-Writers problem', 'Dining-Philosophers problem', 'Producer-Consumer problem', 'None of the mentioned'],
        'correctAnswer': 'Producer-Consumer problem',
        'explanation': 'The bounded buffer problem models producers adding data and consumers removing it from a fixed-size buffer.',
        'selectedAnswer': null,
        'displayNumber': 44
      },
      {
        'questionText': 'What is a reusable resource?',
        'options': ['That can be used by one process at a time and is not depleted by that use', 'That can be used by more than one process at a time', 'That can be shared between various threads', 'None of the mentioned'],
        'correctAnswer': 'That can be used by one process at a time and is not depleted by that use',
        'explanation': 'A reusable resource (e.g., a printer) can be used repeatedly but only by one process at a time.',
        'selectedAnswer': null,
        'displayNumber': 45
      },
      {
        'questionText': 'Which of the following condition is required for a deadlock to be possible?',
        'options': ['Mutual exclusion', 'A process may hold allocated resources while awaiting assignment of other resources', 'No resource can be forcibly removed from a process holding it', 'All of the mentioned'],
        'correctAnswer': 'All of the mentioned',
        'explanation': 'Deadlock requires mutual exclusion, hold and wait, and no preemption (plus circular wait, not listed here).',
        'selectedAnswer': null,
        'displayNumber': 46
      },
      {
        'questionText': 'A system is in the safe state if',
        'options': ['The system can allocate resources to each process in some order and still avoid a deadlock', 'There exist a safe sequence', 'All of the mentioned', 'None of the mentioned'],
        'correctAnswer': 'All of the mentioned',
        'explanation': 'A safe state ensures a sequence exists where all processes can complete without deadlock.',
        'selectedAnswer': null,
        'displayNumber': 47
      },
      {
        'questionText': 'The circular wait condition can be prevented by',
        'options': ['Defining a linear ordering of resource types', 'Using thread', 'Using pipes', 'All of the mentioned'],
        'correctAnswer': 'Defining a linear ordering of resource types',
        'explanation': 'Ordering resources prevents circular dependencies, breaking the circular wait condition.',
        'selectedAnswer': null,
        'displayNumber': 48
      },
      {
        'questionText': 'Which one of the following is the deadlock avoidance algorithm?',
        'options': ['Banker’s algorithm', 'Round-robin algorithm', 'Elevator algorithm', 'Karn’s algorithm'],
        'correctAnswer': 'Banker’s algorithm',
        'explanation': 'Banker’s algorithm avoids deadlock by ensuring resource allocation maintains a safe state.',
        'selectedAnswer': null,
        'displayNumber': 49
      },
      {
        'questionText': 'What is the drawback of banker’s algorithm?',
        'options': ['In advance processes rarely know how much resource they will need', 'The number of processes changes as time progresses', 'Resource once available can disappear', 'All of the mentioned'],
        'correctAnswer': 'All of the mentioned',
        'explanation': 'These factors limit the practicality of Banker’s algorithm in dynamic systems.',
        'selectedAnswer': null,
        'displayNumber': 50
      },
    ],'FLAT': [
      {
        'questionText': 'Which of the following is not a regular language?',
        'options': ['{a^n | n ≥ 0}', '{a^n b^n | n ≥ 0}', '{a, b}', '{a^n b^m | n, m ≥ 0}'],
        'correctAnswer': '{a^n b^n | n ≥ 0}',
        'explanation': '{a^n b^n | n ≥ 0} requires matching counts of a’s and b’s, which cannot be recognized by a finite automaton, making it non-regular.',
        'selectedAnswer': null,
        'displayNumber': 1
      },
      {
        'questionText': 'Which of the following operations is not closed under regular languages?',
        'options': ['Union', 'Intersection', 'Complement', 'Subtraction'],
        'correctAnswer': 'Subtraction',
        'explanation': 'Regular languages are closed under union, intersection, and complement, but not necessarily under subtraction.',
        'selectedAnswer': null,
        'displayNumber': 2
      },
      {
        'questionText': 'Which machine recognizes a context-free language?',
        'options': ['Finite automaton', 'Pushdown automaton', 'Turing machine', 'None of the above'],
        'correctAnswer': 'Pushdown automaton',
        'explanation': 'A pushdown automaton (PDA) recognizes context-free languages using a stack for memory.',
        'selectedAnswer': null,
        'displayNumber': 3
      },
      {
        'questionText': 'A language is regular if and only if it is accepted by a:',
        'options': ['Pushdown automaton', 'Deterministic finite automaton', 'Non-deterministic finite automaton', 'Turing machine'],
        'correctAnswer': 'Deterministic finite automaton',
        'explanation': 'A language is regular if it can be accepted by a DFA (or equivalently an NFA), per the formal definition.',
        'selectedAnswer': null,
        'displayNumber': 4
      },
      {
        'questionText': 'The language accepted by a Pushdown Automaton (PDA) is:',
        'options': ['Regular', 'Context-free', 'Context-sensitive', 'Recursive'],
        'correctAnswer': 'Context-free',
        'explanation': 'PDAs accept context-free languages, which require stack memory beyond finite automata.',
        'selectedAnswer': null,
        'displayNumber': 5
      },
      {
        'questionText': 'A non-deterministic finite automaton (NFA) differs from a deterministic finite automaton (DFA) in the sense that:',
        'options': ['DFA has multiple transitions for a state', 'NFA has only one transition for each state', 'NFA can have multiple transitions for the same input symbol', 'DFA accepts non-regular languages'],
        'correctAnswer': 'NFA can have multiple transitions for the same input symbol',
        'explanation': 'NFAs allow multiple transitions per input symbol and epsilon transitions, unlike DFAs.',
        'selectedAnswer': null,
        'displayNumber': 6
      },
      {
        'questionText': 'The pumping lemma is used to prove that:',
        'options': ['A language is regular', 'A language is not regular', 'A language is context-free', 'A language is deterministic'],
        'correctAnswer': 'A language is not regular',
        'explanation': 'The pumping lemma helps demonstrate that a language cannot be regular by showing it cannot be “pumped”.',
        'selectedAnswer': null,
        'displayNumber': 7
      },
      {
        'questionText': 'Which of the following is a context-free language?',
        'options': ['{a^n b^n | n ≥ 0}', '{a^n b^m | n, m ≥ 0}', '{a^n b^n c^n | n ≥ 0}', '{a^n b^2n | n ≥ 0}'],
        'correctAnswer': '{a^n b^n | n ≥ 0}',
        'explanation': '{a^n b^n | n ≥ 0} is context-free (recognized by a PDA), while {a^n b^n c^n | n ≥ 0} is context-sensitive.',
        'selectedAnswer': null,
        'displayNumber': 8
      },
      {
        'questionText': 'A Turing machine can simulate:',
        'options': ['DFA', 'PDA', 'Both DFA and PDA', 'Neither DFA nor PDA'],
        'correctAnswer': 'Both DFA and PDA',
        'explanation': 'Turing machines, being more powerful, can simulate both DFAs (finite memory) and PDAs (stack memory).',
        'selectedAnswer': null,
        'displayNumber': 9
      },
      {
        'questionText': 'Which of the following is not a property of regular languages?',
        'options': ['Closed under union', 'Closed under intersection', 'Closed under homomorphism', 'Closed under infinite concatenation'],
        'correctAnswer': 'Closed under infinite concatenation',
        'explanation': 'Regular languages are not closed under infinite concatenation, unlike the other operations.',
        'selectedAnswer': null,
        'displayNumber': 10
      },
      {
        'questionText': 'Chomsky hierarchy defines:',
        'options': ['Types of grammars', 'Types of automata', 'Both types of grammars and automata', 'Only regular grammars'],
        'correctAnswer': 'Both types of grammars and automata',
        'explanation': 'The Chomsky hierarchy classifies grammars (Type 0-3) and their corresponding automata.',
        'selectedAnswer': null,
        'displayNumber': 11
      },
      {
        'questionText': 'A context-free grammar (CFG) is used to generate which type of languages?',
        'options': ['Regular', 'Context-free', 'Context-sensitive', 'Unrestricted'],
        'correctAnswer': 'Context-free',
        'explanation': 'CFGs generate context-free languages, recognized by PDAs.',
        'selectedAnswer': null,
        'displayNumber': 12
      },
      {
        'questionText': 'Which of the following is not a part of a Turing machine?',
        'options': ['Input tape', 'Stack', 'Tape head', 'State register'],
        'correctAnswer': 'Stack',
        'explanation': 'A Turing machine uses a tape, not a stack (which is characteristic of a PDA).',
        'selectedAnswer': null,
        'displayNumber': 13
      },
      {
        'questionText': 'In Chomsky Normal Form (CNF), a context-free grammar has:',
        'options': ['Rules of the form A → BC or A → a', 'Rules of the form A → aB', 'Rules of the form A → aB | B', 'Rules of the form A → aB | AB'],
        'correctAnswer': 'Rules of the form A → BC or A → a',
        'explanation': 'CNF restricts productions to A → BC (two non-terminals) or A → a (terminal).',
        'selectedAnswer': null,
        'displayNumber': 14
      },
      {
        'questionText': 'If a language is both context-free and regular, it must be:',
        'options': ['Context-sensitive', 'Recursive', 'Regular', 'Recursively enumerable'],
        'correctAnswer': 'Regular',
        'explanation': 'A language that is both context-free and regular remains regular, as regular languages are a subset of context-free.',
        'selectedAnswer': null,
        'displayNumber': 15
      },
      {
        'questionText': 'Which automaton recognizes deterministic context-free languages?',
        'options': ['DFA', 'DPDA', 'NFA', 'Turing machine'],
        'correctAnswer': 'DPDA',
        'explanation': 'A deterministic PDA (DPDA) recognizes deterministic context-free languages.',
        'selectedAnswer': null,
        'displayNumber': 16
      },
      {
        'questionText': 'The intersection of a regular language and a context-free language is:',
        'options': ['Regular', 'Context-free', 'Context-sensitive', 'Unrestricted'],
        'correctAnswer': 'Context-free',
        'explanation': 'The intersection of a regular and context-free language is context-free, though not necessarily regular.',
        'selectedAnswer': null,
        'displayNumber': 17
      },
      {
        'questionText': 'In finite automata, the state that does not lead to any further transitions is called:',
        'options': ['Final state', 'Trap state', 'Initial state', 'None of the above'],
        'correctAnswer': 'Trap state',
        'explanation': 'A trap state has no outgoing transitions and is not necessarily a final state.',
        'selectedAnswer': null,
        'displayNumber': 18
      },
      {
        'questionText': 'Which of the following is undecidable?',
        'options': ['Determining if a DFA accepts a language', 'Determining if two regular expressions define the same language', 'Determining if a context-free grammar is ambiguous', 'All of the above'],
        'correctAnswer': 'Determining if a context-free grammar is ambiguous',
        'explanation': 'CFG ambiguity is undecidable; DFA and regular expression problems are decidable.',
        'selectedAnswer': null,
        'displayNumber': 19
      },
      {
        'questionText': 'A pushdown automaton has which of the following memory structures?',
        'options': ['Queue', 'Stack', 'Tape', 'Registers'],
        'correctAnswer': 'Stack',
        'explanation': 'A PDA uses a stack to manage memory, enabling it to recognize context-free languages.',
        'selectedAnswer': null,
        'displayNumber': 20
      },
      {
        'questionText': 'Which class of languages can be accepted by a Turing machine?',
        'options': ['Regular', 'Context-free', 'Recursively enumerable', 'Unrestricted'],
        'correctAnswer': 'Recursively enumerable',
        'explanation': 'Turing machines accept recursively enumerable languages, the broadest class in the Chomsky hierarchy.',
        'selectedAnswer': null,
        'displayNumber': 21
      },
      {
        'questionText': 'Which type of grammar generates context-sensitive languages?',
        'options': ['Type 0', 'Type 1', 'Type 2', 'Type 3'],
        'correctAnswer': 'Type 1',
        'explanation': 'Type 1 (context-sensitive) grammars generate context-sensitive languages.',
        'selectedAnswer': null,
        'displayNumber': 22
      },
      {
        'questionText': 'The halting problem is:',
        'options': ['Decidable', 'Semi-decidable', 'Undecidable', 'Recursive'],
        'correctAnswer': 'Undecidable',
        'explanation': 'The halting problem (whether a Turing machine halts on an input) is proven undecidable.',
        'selectedAnswer': null,
        'displayNumber': 23
      },
      {
        'questionText': 'Which of the following describes the pumping lemma for context-free languages?',
        'options': ['Any string in the language can be written as xyz', 'Any string in the language can be divided into five parts', 'Any sufficiently long string in the language can be written as uvwxy', 'The language can be expressed using regular expressions'],
        'correctAnswer': 'Any sufficiently long string in the language can be written as uvwxy',
        'explanation': 'The pumping lemma for context-free languages states a string can be split into uvwxy, with pumpable parts.',
        'selectedAnswer': null,
        'displayNumber': 24
      },
      {
        'questionText': 'Ambiguity in a grammar implies that:',
        'options': ['There is more than one leftmost derivation for some strings', 'There is no unique parse tree', 'The grammar generates multiple languages', 'Both A and B'],
        'correctAnswer': 'Both A and B',
        'explanation': 'Ambiguity means multiple derivations or parse trees exist for some strings in the language.',
        'selectedAnswer': null,
        'displayNumber': 25
      },
      {
        'questionText': 'In a deterministic finite automaton (DFA), each state has:',
        'options': ['Exactly one transition for each input symbol', 'No transitions for input symbols', 'More than one transition for input symbols', 'Multiple transitions to the same state'],
        'correctAnswer': 'Exactly one transition for each input symbol',
        'explanation': 'A DFA is deterministic, requiring exactly one transition per input symbol per state.',
        'selectedAnswer': null,
        'displayNumber': 26
      },
      {
        'questionText': 'A language is recursively enumerable if:',
        'options': ['It can be accepted by a deterministic PDA', 'It can be accepted by a Turing machine', 'It can be accepted by a finite automaton', 'It can be accepted by a non-deterministic PDA'],
        'correctAnswer': 'It can be accepted by a Turing machine',
        'explanation': 'Recursively enumerable languages are those accepted by a Turing machine, which may not always halt.',
        'selectedAnswer': null,
        'displayNumber': 27
      },
      {
        'questionText': 'Which of the following is an undecidable problem?',
        'options': ['Equivalence of two DFAs', 'Ambiguity of a CFG', 'Emptiness of a regular language', 'Membership problem for regular languages'],
        'correctAnswer': 'Ambiguity of a CFG',
        'explanation': 'CFG ambiguity is undecidable, while DFA equivalence and regular language properties are decidable.',
        'selectedAnswer': null,
        'displayNumber': 28
      },
      {
        'questionText': 'A finite automaton accepts a language if:',
        'options': ['It halts for all strings', 'It halts only for accepting strings', 'It reaches a final state for some strings', 'It rejects all strings'],
        'correctAnswer': 'It reaches a final state for some strings',
        'explanation': 'A string is accepted if the automaton ends in a final state after processing it.',
        'selectedAnswer': null,
        'displayNumber': 29
      },
      {
        'questionText': 'Which of the following is not a valid transition in a Turing machine?',
        'options': ['Left shift', 'Right shift', 'No shift', 'Up shift'],
        'correctAnswer': 'Up shift',
        'explanation': 'Turing machine tape heads move left, right, or stay (no shift), but not up.',
        'selectedAnswer': null,
        'displayNumber': 30
      },
      {
        'questionText': 'A context-free grammar can be converted into:',
        'options': ['A regular grammar', 'A Chomsky normal form grammar', 'A finite automaton', 'A context-sensitive grammar'],
        'correctAnswer': 'A Chomsky normal form grammar',
        'explanation': 'CFGs can be converted to Chomsky Normal Form (CNF), but not necessarily to regular grammars or automata.',
        'selectedAnswer': null,
        'displayNumber': 31
      },
      {
        'questionText': 'The language {a^n b^n | n ≥ 0} is accepted by:',
        'options': ['DFA', 'PDA', 'Turing machine', 'None of the above'],
        'correctAnswer': 'PDA',
        'explanation': '{a^n b^n | n ≥ 0} is context-free, requiring a PDA’s stack; a DFA cannot recognize it.',
        'selectedAnswer': null,
        'displayNumber': 32
      },
      {
        'questionText': 'A Turing machine can compute:',
        'options': ['Any recursive function', 'Only regular functions', 'Context-free functions', 'Only context-sensitive functions'],
        'correctAnswer': 'Any recursive function',
        'explanation': 'Turing machines can compute any recursive (computable) function, per the Church-Turing thesis.',
        'selectedAnswer': null,
        'displayNumber': 33
      },
      {
        'questionText': 'The complement of a context-free language is:',
        'options': ['Regular', 'Context-free', 'Context-sensitive', 'Recursively enumerable'],
        'correctAnswer': 'Recursively enumerable',
        'explanation': 'Context-free languages are not closed under complement; their complements are recursively enumerable.',
        'selectedAnswer': null,
        'displayNumber': 34
      },
      {
        'questionText': 'A nondeterministic pushdown automaton can recognize:',
        'options': ['Regular languages', 'Context-free languages', 'Context-sensitive languages', 'Recursive languages'],
        'correctAnswer': 'Context-free languages',
        'explanation': 'NPDA recognizes context-free languages, leveraging nondeterminism and a stack.',
        'selectedAnswer': null,
        'displayNumber': 35
      },
      {
        'questionText': 'The intersection of two context-free languages is:',
        'options': ['Always context-free', 'Sometimes context-free', 'Never context-free', 'Regular'],
        'correctAnswer': 'Sometimes context-free',
        'explanation': 'The intersection of two context-free languages is not always context-free (e.g., {a^n b^n c^n}).',
        'selectedAnswer': null,
        'displayNumber': 36
      },
      {
        'questionText': 'A language is deterministic context-free if:',
        'options': ['It can be accepted by a DPDA', 'It can be accepted by a PDA', 'It can be accepted by a DFA', 'It can be accepted by a Turing machine'],
        'correctAnswer': 'It can be accepted by a DPDA',
        'explanation': 'Deterministic context-free languages are accepted by deterministic PDAs (DPDAs).',
        'selectedAnswer': null,
        'displayNumber': 37
      },
      {
        'questionText': 'Which of the following describes a context-sensitive language?',
        'options': ['A language that requires memory beyond a finite automaton', 'A language that is recognized by a Turing machine with a linear bounded tape', 'A language that cannot be expressed using a CFG', 'Both A and B'],
        'correctAnswer': 'Both A and B',
        'explanation': 'Context-sensitive languages need more than finite memory and are recognized by linear bounded automata.',
        'selectedAnswer': null,
        'displayNumber': 38
      },
      {
        'questionText': 'Chomsky type-1 grammars generate:',
        'options': ['Regular languages', 'Context-free languages', 'Context-sensitive languages', 'Unrestricted languages'],
        'correctAnswer': 'Context-sensitive languages',
        'explanation': 'Type-1 (context-sensitive) grammars generate context-sensitive languages.',
        'selectedAnswer': null,
        'displayNumber': 39
      },
      {
        'questionText': 'The halting problem states that:',
        'options': ['Every Turing machine halts on all inputs', 'There exists a Turing machine that cannot halt on some inputs', 'Every problem is solvable by a Turing machine', 'None of the above'],
        'correctAnswer': 'None of the above',
        'explanation': 'The halting problem states it’s undecidable whether a Turing machine halts on a given input.',
        'selectedAnswer': null,
        'displayNumber': 40
      },
      {
        'questionText': 'The class of languages that can be recognized by a non-deterministic pushdown automaton is:',
        'options': ['Regular languages', 'Context-free languages', 'Context-sensitive languages', 'Recursive languages'],
        'correctAnswer': 'Context-free languages',
        'explanation': 'NPDAs recognize context-free languages, leveraging nondeterminism and stack memory.',
        'selectedAnswer': null,
        'displayNumber': 41
      },
      {
        'questionText': 'Which of the following problems is decidable?',
        'options': ['Whether a given CFG is ambiguous', 'Whether a given regular language is finite', 'Whether a given Turing machine halts on all inputs', 'Whether two CFGs generate the same language'],
        'correctAnswer': 'Whether a given regular language is finite',
        'explanation': 'Finiteness of a regular language is decidable; CFG ambiguity and TM halting are not.',
        'selectedAnswer': null,
        'displayNumber': 42
      },
      {
        'questionText': 'Which of the following is an example of a non-regular language?',
        'options': ['{a^n b^n | n ≥ 0}', '{a^n | n ≥ 0}', '{a, b}*', '{a^n b^m | n, m ≥ 0}'],
        'correctAnswer': '{a^n b^n | n ≥ 0}',
        'explanation': '{a^n b^n | n ≥ 0} requires counting, making it context-free but not regular.',
        'selectedAnswer': null,
        'displayNumber': 43
      },
      {
        'questionText': 'The language {a^n b^n | n ≥ 0} is:',
        'options': ['Regular', 'Context-free', 'Context-sensitive', 'Recursive'],
        'correctAnswer': 'Context-free',
        'explanation': '{a^n b^n | n ≥ 0} is context-free, recognized by a PDA, but not regular.',
        'selectedAnswer': null,
        'displayNumber': 44
      },
      {
        'questionText': 'Which of the following statements is true?',
        'options': ['Every regular language is also context-free', 'Every context-free language is also regular', 'Every context-sensitive language is also context-free', 'None of the above'],
        'correctAnswer': 'Every regular language is also context-free',
        'explanation': 'Regular languages are a subset of context-free languages.',
        'selectedAnswer': null,
        'displayNumber': 45
      },
      {
        'questionText': 'In a Turing machine, the tape is:',
        'options': ['Finite and rewritable', 'Infinite in both directions', 'Infinite in one direction', 'None of the above'],
        'correctAnswer': 'Infinite in both directions',
        'explanation': 'A Turing machine’s tape is infinite in both directions, allowing unbounded computation.',
        'selectedAnswer': null,
        'displayNumber': 46
      },
      {
        'questionText': 'A Turing machine is said to be in an undecidable state if:',
        'options': ['It reaches a final state', 'It halts with an accepting state', 'It never halts', 'It always rejects'],
        'correctAnswer': 'It never halts',
        'explanation': 'An undecidable state implies the machine loops indefinitely, as halting is undecidable.',
        'selectedAnswer': null,
        'displayNumber': 47
      },
      {
        'questionText': 'The number of states required for a DFA to recognize the language {a^n | n mod k = 0} is:',
        'options': ['k', 'k+1', '2k', '2^(k)'],
        'correctAnswer': 'k',
        'explanation': 'A DFA recognizing {a^n | n mod k = 0} needs k states to track the remainder modulo k.',
        'selectedAnswer': null,
        'displayNumber': 48
      },
      {
        'questionText': 'Which of the following is false about context-free grammars?',
        'options': ['They can be represented using a pushdown automaton', 'They can generate languages with equal numbers of a’s and b’s', 'They can generate languages requiring memory beyond a finite automaton', 'They can generate {a^n b^n c^n | n ≥ 0}'],
        'correctAnswer': 'They can generate {a^n b^n c^n | n ≥ 0}',
        'explanation': '{a^n b^n c^n | n ≥ 0} is context-sensitive, not context-free; CFGs cannot enforce three equal counts.',
        'selectedAnswer': null,
        'displayNumber': 49
      },
      {
        'questionText': 'Which of the following languages is recognized by a linear bounded automaton?',
        'options': ['Regular languages', 'Context-free languages', 'Context-sensitive languages', 'Unrestricted languages'],
        'correctAnswer': 'Context-sensitive languages',
        'explanation': 'A linear bounded automaton (LBA) recognizes context-sensitive languages with tape space linear to input size.',
        'selectedAnswer': null,
        'displayNumber': 50
      }
    ]
  };

  late List<Map<String, dynamic>> _questions;

  @override
  void initState() {
    super.initState();
    Provider.of<CurrentPageProvider>(context, listen: false).setCurrentPage('subjectmocktest');
    _questions = _questionBank[widget.subject] ?? [];
    _randomizeQuestions(); // Randomize questions when the page is opened
  }

  @override
  void dispose() {
    Provider.of<CurrentPageProvider>(context, listen: false).setCurrentPage('home');
    if (_testStarted) {
      _timer.cancel();
    }
    super.dispose();
  }

  void _randomizeQuestions() {
    _questions.shuffle(Random());
    for (int i = 0; i < _questions.length; i++) {
      _questions[i] = Map.from(_questions[i]); // Create a new map to avoid modifying the original
      _questions[i]['selectedAnswer'] = null; // Reset selected answers
      _questions[i]['displayNumber'] = i + 1; // Reassign display numbers
    }
  }

  void _startTest() {
    setState(() {
      _testStarted = true;
      _testSubmitted = false;
      _correctAnswers = 0;
      _duration = const Duration(hours: 1,minutes: 30); // Reset duration
      // No need to call _randomizeQuestions here; it's already done in initState
    });
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_duration.inSeconds == 0) {
        _timer.cancel();
        _submitTest();
      } else {
        setState(() {
          _duration = _duration - const Duration(seconds: 1);
        });
      }
    });
  }

  void _selectAnswer(int questionIndex, String answer) {
    if (_testSubmitted) return;

    setState(() {
      _questions[questionIndex]['selectedAnswer'] = answer;
    });
  }

  void _submitTest() {
    if (_testSubmitted) return;

    _timer.cancel();
    int correct = 0;

    for (var question in _questions) {
      if (question['selectedAnswer'] == question['correctAnswer']) {
        correct++;
      }
    }

    setState(() {
      _correctAnswers = correct;
      _testSubmitted = true;
    });

    // Calculate percentage
    double percentage = (_correctAnswers / _questions.length * 100);

    // Determine emoji and message based on percentage
    String emoji;
    String message;
    Color emojiColor;
    if (percentage >= 70) {
      emoji = '😊👍'; // Happy face with thumbs up
      message = 'Great Job!';
      emojiColor = Colors.green;
    } else if (percentage >= 50) {
      emoji = '🙂'; // Neutral smile
      message = 'Good Effort!';
      emojiColor = Colors.blue;
    } else if (percentage >= 30) {
      emoji = '😐'; // Neutral face
      message = 'Keep Practicing!';
      emojiColor = Colors.orange;
    } else {
      emoji = '😞'; // Sad face
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
                lightGreen.withOpacity(0.5),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: darkGreen.withOpacity(0.2),
                spreadRadius: 5,
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Emoji with a circular background
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
              // Message
              Text(
                message,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: darkGreen,
                ),
              ),
              const SizedBox(height: 16),
              // Score and Percentage
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
              // Action Button
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
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
            if (_testStarted) SizedBox(height: statusBarHeight),
            if (_testStarted)
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
                      'Time Left: ${_duration.inMinutes}:${(_duration.inSeconds % 60).toString().padLeft(2, '0')}',
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
              child: !_testStarted
                  ? _buildStartTestView()
                  : _questions.isEmpty
                  ? _buildNoQuestionsView()
                  : _buildQuestionsListView(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _testStarted && _questions.isNotEmpty
          ? BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ElevatedButton(
            onPressed: _testSubmitted ? null : _submitTest,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryGreen,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: Text(_testSubmitted ? 'Test Submitted' : 'Submit Test'),
          ),
        ),
      )
          : null,
    );
  }

  Widget _buildStartTestView() {
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
            '${widget.subject} Mock Test',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Practice Test',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 24),
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
                  'Test Information',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _buildInfoRow('Questions', '${_questions.length} questions'),
                _buildInfoRow('Duration', '1 Hour 30 minutes'),
                _buildInfoRow('Question Type', 'Multiple Choice'),
              ],
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _startTest,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryGreen,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            child: const Text('Start Test'),
          ),
          const SizedBox(height: 16),
          Text(
            'Note: The timer will start once you begin the test',
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
            'Questions for ${widget.subject} have not been added yet.',
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
        final showCorrectAnswer = _testSubmitted;

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
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
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
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