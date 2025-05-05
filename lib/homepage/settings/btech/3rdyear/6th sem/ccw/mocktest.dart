import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../../../main.dart';

class MockTestPage extends StatefulWidget {
  final String subject;
  final String module;
  final Color subjectColor;
  final String? mockTestNumber;

  const MockTestPage({
    super.key,
    required this.subject,
    required this.module,
    required this.subjectColor,
    this.mockTestNumber,
  });

  @override
  State<MockTestPage> createState() => _MockTestPageState();
}

class _MockTestPageState extends State<MockTestPage> {
  bool _isLoading = false;
  List<Map<String, dynamic>> _allQuestions = [];
  List<Map<String, dynamic>> _selectedQuestions = [];
  Map<int, String> _selectedAnswers = {};
  bool _testSubmitted = false;
  bool _testStarted = false;
  int _correctAnswers = 0;
  bool _showErrorMessage = false;
  String _errorMessage = '';
  Duration _duration = const Duration(hours: 0, minutes: 30); // 1 hour 30 minutes
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    Provider.of<CurrentPageProvider>(context, listen: false).setCurrentPage('mocktest');
    _loadQuestions(); // Load questions based on subject, module, and mock test number
  }

  void _startTest() {
    setState(() {
      _testStarted = true;
      _randomizeQuestions();
    });
    _startTimer();
  }

  void _randomizeQuestions() {
    List<Map<String, dynamic>> questionsCopy = List.from(_allQuestions);
    questionsCopy.shuffle(Random());
    _selectedQuestions = questionsCopy;
    for (int i = 0; i < _selectedQuestions.length; i++) {
      _selectedQuestions[i] = Map.from(_selectedQuestions[i]);
      _selectedQuestions[i]['displayNumber'] = i + 1;
    }
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

  void _loadQuestions() {
    setState(() {
      _isLoading = true;
    });

    // Define a map of questions for different subjects, modules, and mock tests
    final Map<String, List<Map<String, dynamic>>> questionBank = {
      // COA Subject
      "COA_Module 1_Mock Test 1": [
        {
          "questionText": "How many buses are connected as part of the 8085A microprocessor?",
          "options": ["2", "3", "5", "8"],
          "correctAnswer": "3",
          "explanation": "The 8085A microprocessor has 3 buses: Address bus, Data bus, and Control bus."
        },
        {
          "questionText": "The branch logic that provides decision-making capabilities in the control unit is:",
          "options": ["Conditional transfer", "Unconditional transfer", "None of the above"],
          "correctAnswer": "Conditional transfer",
          "explanation": "Conditional transfer allows the control unit to make decisions based on certain conditions."
        },
        {
          "questionText": "Which bus is bidirectional in 8086?",
          "options": ["Control bus", "Address bus", "Multiplexed bus"],
          "correctAnswer": "Multiplexed bus",
          "explanation": "The multiplexed bus in 8086 is bidirectional, allowing data to flow in both directions."
        },
        {
          "questionText": "The data bus of 8086 is:",
          "options": ["16-bit wide", "32-bit wide", "4-bit wide"],
          "correctAnswer": "16-bit wide",
          "explanation": "The 8086 microprocessor has a 16-bit wide data bus."
        },
        {
          "questionText": "Which bus is bidirectional?",
          "options": ["Address bus", "Control bus", "Data bus", "None of the above"],
          "correctAnswer": "Data bus",
          "explanation": "The data bus is bidirectional as it allows data to flow in both directions."
        },
        {
          "questionText": "Which of the following is NOT a part of the Execution Unit (EU)?",
          "options": ["ALU", "General purpose registers", "Clock"],
          "correctAnswer": "Clock",
          "explanation": "The clock is not part of the Execution Unit (EU); it is part of the timing and control unit."
        },
        {
          "questionText": "Which is the input of the control unit?",
          "options": ["ALU output", "Subtractor", "Instruction Register"],
          "correctAnswer": "Instruction Register",
          "explanation": "The control unit takes input from the Instruction Register to decode and execute instructions."
        },
        {
          "questionText": "A bus organization consists of how many registers?",
          "options": ["3", "5", "7"],
          "correctAnswer": "7",
          "explanation": "A typical bus organization consists of 7 registers: MAR, MDR, IR, PC, Accumulator, Data Register, and Address Register."
        },
        {
          "questionText": "What is the main function of the control unit in a computer?",
          "options": ["Perform arithmetic operations", "Manage program execution", "Control data flow between CPU and memory"],
          "correctAnswer": "Control data flow between CPU and memory",
          "explanation": "The control unit manages data flow between the CPU and memory, ensuring proper execution of instructions."
        },
        {
          "questionText": "The control unit works in coordination with which component?",
          "options": ["RAM", "Registers", "ALU"],
          "correctAnswer": "ALU",
          "explanation": "The control unit coordinates with the ALU to execute arithmetic and logical operations."
        },
        {
          "questionText": "Which part of the CPU is responsible for executing arithmetic and logic operations?",
          "options": ["Control Unit", "ALU", "Registers"],
          "correctAnswer": "ALU",
          "explanation": "The Arithmetic Logic Unit (ALU) performs arithmetic and logic operations."
        },
        {
          "questionText": "The address bus in a computer system is used to:",
          "options": ["Transfer data between devices", "Send control signals", "Specify memory locations"],
          "correctAnswer": "Specify memory locations",
          "explanation": "The address bus carries memory addresses to specify locations in memory."
        },
        {
          "questionText": "Which register keeps track of the instruction currently being executed?",
          "options": ["Memory Address Register", "Program Counter", "Instruction Register"],
          "correctAnswer": "Instruction Register",
          "explanation": "The Instruction Register holds the instruction currently being executed."
        },
        {
          "questionText": "In the CPU, the register that stores intermediate results is called:",
          "options": ["Data Register", "Accumulator", "Instruction Register"],
          "correctAnswer": "Accumulator",
          "explanation": "The Accumulator stores intermediate results during arithmetic and logic operations."
        },
        {
          "questionText": "A microprocessor is designed to perform:",
          "options": ["Only input operations", "Only output operations", "Both arithmetic and logic operations"],
          "correctAnswer": "Both arithmetic and logic operations",
          "explanation": "A microprocessor performs both arithmetic and logic operations."
        },

      ],
      'COA_Module 1_Mock Test 2': [
        {
          "questionText": "The function of the bus in a computer system is to:",
          "options": ["Store data permanently", "Transfer data between CPU, memory, and I/O devices", "Decode instructions"],
          "correctAnswer": "Transfer data between CPU, memory, and I/O devices",
          "explanation": "The bus facilitates data transfer between the CPU, memory, and I/O devices."
        },
        {
          "questionText": "What does the term 'fetch' refer to in the fetch-execute cycle?",
          "options": ["Retrieving an instruction from memory", "Storing results in registers", "Executing an arithmetic operation"],
          "correctAnswer": "Retrieving an instruction from memory",
          "explanation": "Fetch refers to retrieving an instruction from memory during the fetch-execute cycle."
        },
        {
          "questionText": "The width of the data bus determines:",
          "options": ["The number of memory locations", "The number of bits transferred at a time", "The speed of the processor"],
          "correctAnswer": "The number of bits transferred at a time",
          "explanation": "The width of the data bus determines how many bits can be transferred simultaneously."
        },
        {
          "questionText": "What is the purpose of an instruction decoder in a CPU?",
          "options": ["Execute instructions", "Convert instructions into control signals", "Store program data"],
          "correctAnswer": "Convert instructions into control signals",
          "explanation": "The instruction decoder converts instructions into control signals for execution."
        },
        {
          "questionText": "What component in the CPU is responsible for controlling data flow?",
          "options": ["ALU", "Control Unit", "Register File"],
          "correctAnswer": "Control Unit",
          "explanation": "The Control Unit manages and controls data flow within the CPU."
        },
        {
          "questionText": "Which part of the computer is responsible for executing instructions?",
          "options": ["Control Unit", "Memory Unit", "Arithmetic Logic Unit (ALU)", "Input Unit"],
          "correctAnswer": "Arithmetic Logic Unit (ALU)",
          "explanation": "The ALU executes arithmetic and logic instructions."
        },
        {
          "questionText": "Which type of memory is directly accessible by the CPU?",
          "options": ["Hard Disk", "RAM", "Optical Disk", "USB Drive"],
          "correctAnswer": "RAM",
          "explanation": "RAM (Random Access Memory) is directly accessible by the CPU."
        },
        {
          "questionText": "What is the main function of the control unit in the CPU?",
          "options": ["Perform arithmetic operations", "Manage program execution and data flow", "Store data permanently", "Control input/output devices"],
          "correctAnswer": "Manage program execution and data flow",
          "explanation": "The control unit manages program execution and data flow within the CPU."
        },
        {
          "questionText": "The component of the CPU that holds the instructions currently being executed is called:",
          "options": ["Accumulator", "Instruction Register", "Memory Address Register", "Stack Pointer"],
          "correctAnswer": "Instruction Register",
          "explanation": "The Instruction Register holds the instructions currently being executed."
        },
        {
          "questionText": "Which bus carries data between the CPU and memory?",
          "options": ["Address Bus", "Data Bus", "Control Bus", "System Bus"],
          "correctAnswer": "Data Bus",
          "explanation": "The Data Bus carries data between the CPU and memory."
        },
        {
          "questionText": "The width of the address bus determines:",
          "options": ["The number of memory locations accessible", "The speed of data transfer", "The power consumption of the CPU", "The size of the cache memory"],
          "correctAnswer": "The number of memory locations accessible",
          "explanation": "The width of the address bus determines the number of memory locations that can be addressed."
        },
        {
          "questionText": "Which component is responsible for decoding the instructions in a computer?",
          "options": ["ALU", "Control Unit", "Registers", "RAM"],
          "correctAnswer": "Control Unit",
          "explanation": "The Control Unit decodes instructions in a computer."
        },
        {
          "questionText": "The control unit generates control signals to manage which of the following?",
          "options": ["Memory operations", "Instruction execution", "Data transfer between components", "All of the above"],
          "correctAnswer": "All of the above",
          "explanation": "The control unit generates control signals to manage memory operations, instruction execution, and data transfer."
        },
        {
          "questionText": "What is the role of a register in a CPU?",
          "options": ["Store data permanently", "Temporarily hold data and instructions during processing", "Transfer data to external devices", "Manage power supply in the CPU"],
          "correctAnswer": "Temporarily hold data and instructions during processing",
          "explanation": "Registers temporarily hold data and instructions during processing."
        },
        {
          "questionText": "What is the full form of CPU?",
          "options": ["Computer Processing Unit", "Central Processing Unit", "Control Processing Unit", "Core Processing Unit"],
          "correctAnswer": "Central Processing Unit",
          "explanation": "CPU stands for Central Processing Unit, which is the brain of the computer."
        }
      ],
      'COA_Module 2_Mock Test 1': [

        {
          "questionText": "What is an opcode in an instruction?",
          "options": ["The operation performed by the instruction", "The data to be processed", "The memory address of data", "The hardware signal for execution"],
          "correctAnswer": "The operation performed by the instruction",
          "explanation": "The opcode specifies the operation to be performed by the instruction."
        },
        {
          "questionText": "Which of the following is not an addressing mode?",
          "options": ["Immediate", "Indexed", "Concurrent", "Direct"],
          "correctAnswer": "Concurrent",
          "explanation": "Concurrent is not an addressing mode; it refers to simultaneous execution."
        },
        {
          "questionText": "Which phase of the instruction cycle fetches the instruction from memory?",
          "options": ["Decode phase", "Execute phase", "Fetch phase", "Write-back phase"],
          "correctAnswer": "Fetch phase",
          "explanation": "The fetch phase retrieves the instruction from memory."
        },
        {
          "questionText": "Which addressing mode uses the value directly specified in the instruction?",
          "options": ["Direct Addressing", "Indirect Addressing", "Immediate Addressing", "Indexed Addressing"],
          "correctAnswer": "Immediate Addressing",
          "explanation": "Immediate Addressing uses the value directly specified in the instruction."
        },
        {
          "questionText": "Which register is used to hold the instruction currently being executed?",
          "options": ["Program Counter", "Instruction Register", "Memory Address Register", "Stack Pointer"],
          "correctAnswer": "Instruction Register",
          "explanation": "The Instruction Register holds the instruction currently being executed."
        },
        {
          "questionText": "Which addressing mode uses a register to hold the memory address of the operand?",
          "options": ["Register Indirect Addressing", "Direct Addressing", "Immediate Addressing", "Indexed Addressing"],
          "correctAnswer": "Register Indirect Addressing",
          "explanation": "Register Indirect Addressing uses a register to hold the memory address of the operand."
        },
        {
          "questionText": "In which addressing mode is the operand located in memory, and its address is specified in the instruction?",
          "options": ["Direct Addressing", "Immediate Addressing", "Register Addressing", "Indexed Addressing"],
          "correctAnswer": "Direct Addressing",
          "explanation": "Direct Addressing specifies the memory address of the operand in the instruction."
        },
        {
          "questionText": "Which instruction format does not require an operand?",
          "options": ["Zero-address instructions", "One-address instructions", "Two-address instructions", "Three-address instructions"],
          "correctAnswer": "Zero-address instructions",
          "explanation": "Zero-address instructions do not require an operand; they operate on implicit data."
        },
        {
          "questionText": "Which type of instruction is used to transfer control unconditionally?",
          "options": ["Arithmetic Instructions", "Logical Instructions", "Control Transfer Instructions", "Data Transfer Instructions"],
          "correctAnswer": "Control Transfer Instructions",
          "explanation": "Control Transfer Instructions unconditionally transfer control to another part of the program."
        },
        {
          "questionText": "What happens during the decode phase of an instruction cycle?",
          "options": ["The instruction is fetched from memory", "The instruction is executed", "The instruction is translated into control signals", "The operand is written back to memory"],
          "correctAnswer": "The instruction is translated into control signals",
          "explanation": "The decode phase translates the instruction into control signals for execution."
        },
        {
          "questionText": "What is the purpose of an operand in an instruction?",
          "options": ["Specifies the operation to be performed", "Stores intermediate values", "Provides the data to be operated on", "Generates control signals"],
          "correctAnswer": "Provides the data to be operated on",
          "explanation": "The operand provides the data to be operated on by the instruction."
        },
        {
          "questionText": "Which of the following is an example of an arithmetic instruction?",
          "options": ["MOV", "ADD", "JMP", "CMP"],
          "correctAnswer": "ADD",
          "explanation": "ADD is an arithmetic instruction used to perform addition."
        },
        {
          "questionText": "Which instruction is used to compare two values?",
          "options": ["CMP", "ADD", "MOV", "XOR"],
          "correctAnswer": "CMP",
          "explanation": "CMP is used to compare two values."
        },
        {
          "questionText": "Which type of instruction changes the sequence of execution?",
          "options": ["Logical Instructions", "Control Instructions", "Arithmetic Instructions", "Shift Instructions"],
          "correctAnswer": "Control Instructions",
          "explanation": "Control Instructions change the sequence of execution, such as jumps or branches."
        },
        {
          "questionText": "In indirect addressing mode, the operand is found in:",
          "options": ["The instruction itself", "A memory address stored in a register", "The accumulator", "The program counter"],
          "correctAnswer": "A memory address stored in a register",
          "explanation": "In indirect addressing mode, the operand is found at a memory address stored in a register."
        },
      ],
      'COA_Module 2_Mock Test 2': [
        {
          "questionText": "Which instruction is used to move data between registers and memory?",
          "options": ["ADD", "JMP", "MOV", "CMP"],
          "correctAnswer": "MOV",
          "explanation": "MOV is used to move data between registers and memory."
        },
        {
          "questionText": "The operand of an instruction can be stored in:",
          "options": ["A register", "Memory", "Immediate value in the instruction itself", "All of the above"],
          "correctAnswer": "All of the above",
          "explanation": "The operand can be stored in a register, memory, or as an immediate value in the instruction."
        },
        {
          "questionText": "In stack-based addressing, operands are accessed from:",
          "options": ["Registers", "Memory", "Stack", "Instruction Register"],
          "correctAnswer": "Stack",
          "explanation": "In stack-based addressing, operands are accessed from the stack."
        },
        {
          "questionText": "Which type of addressing mode requires adding a displacement value to a base address?",
          "options": ["Indexed Addressing", "Direct Addressing", "Indirect Addressing", "Register Addressing"],
          "correctAnswer": "Indexed Addressing",
          "explanation": "Indexed Addressing adds a displacement value to a base address to calculate the effective address."
        },
        {
          "questionText": "Which instruction is used to load a value directly into a register?",
          "options": ["MOV", "JMP", "ADD", "CMP"],
          "correctAnswer": "MOV",
          "explanation": "MOV is used to load a value directly into a register."
        },
        {
          "questionText": "Which of the following is an example of a data transfer instruction?",
          "options": ["MOV", "ADD", "JMP", "AND"],
          "correctAnswer": "MOV",
          "explanation": "MOV is a data transfer instruction used to move data."
        },
        {
          "questionText": "The fetch cycle is responsible for:",
          "options": ["Executing the instruction", "Fetching the instruction from memory", "Decoding the instruction", "Performing ALU operations"],
          "correctAnswer": "Fetching the instruction from memory",
          "explanation": "The fetch cycle retrieves the instruction from memory."
        },
        {
          "questionText": "Which register holds the address of the next instruction to be executed?",
          "options": ["Instruction Register", "Program Counter", "Stack Pointer", "Accumulator"],
          "correctAnswer": "Program Counter",
          "explanation": "The Program Counter holds the address of the next instruction to be executed."
        },
        {
          "questionText": "Which addressing mode specifies the operand directly in the instruction?",
          "options": ["Direct Addressing", "Immediate Addressing", "Indexed Addressing", "Indirect Addressing"],
          "correctAnswer": "Immediate Addressing",
          "explanation": "Immediate Addressing specifies the operand directly in the instruction."
        },
        {
          "questionText": "Which instruction is used to copy data from memory to a register?",
          "options": ["JMP", "MOV", "ADD", "CMP"],
          "correctAnswer": "MOV",
          "explanation": "MOV is used to copy data from memory to a register."
        },
        {
          "questionText": "Which of the following instructions is used to transfer control to a different part of the program?",
          "options": ["MOV", "JMP", "ADD", "CMP"],
          "correctAnswer": "JMP",
          "explanation": "JMP is used to transfer control to a different part of the program."
        },
        {
          "questionText": "The execute phase of an instruction cycle:",
          "options": ["Stores the operand", "Fetches the instruction", "Decodes the instruction", "Executes the operation specified by the instruction"],
          "correctAnswer": "Executes the operation specified by the instruction",
          "explanation": "The execute phase performs the operation specified by the instruction."
        },
        {
          "questionText": "Which register temporarily stores the instruction being fetched?",
          "options": ["Memory Address Register (MAR)", "Instruction Register (IR)", "Program Counter (PC)", "Accumulator"],
          "correctAnswer": "Instruction Register (IR)",
          "explanation": "The Instruction Register (IR) temporarily stores the instruction being fetched."
        },
        {
          "questionText": "Which of the following is a logical instruction?",
          "options": ["AND", "ADD", "MOV", "JMP"],
          "correctAnswer": "AND",
          "explanation": "AND is a logical instruction used for bitwise operations."
        },
        {
          "questionText": "In indirect addressing mode, the operand is found in:",
          "options": ["The instruction itself", "A memory address stored in a register", "The accumulator", "The program counter"],
          "correctAnswer": "A memory address stored in a register",
          "explanation": "In indirect addressing mode, the operand is found at a memory address stored in a register."
        },
      ],
      'COA_Module 3_Mock Test 1': [
        {
          'questionText': 'Which component of the CPU performs arithmetic and logic operations?',
          'options': ['Control Unit', 'Arithmetic Logic Unit (ALU)', 'Register File', 'Cache Memory'],
          'correctAnswer': 'Arithmetic Logic Unit (ALU)',
          'explanation': 'The ALU is responsible for performing arithmetic (e.g., addition, subtraction) and logical operations (e.g., AND, OR) in the CPU.'
        },
        {
          'questionText': 'What is the primary function of pipelining in a processor?',
          'options': ['Reduce power consumption', 'Increase instruction execution speed', 'Reduce the number of registers', 'Improve memory access time'],
          'correctAnswer': 'Increase instruction execution speed',
          'explanation': 'Pipelining allows multiple instructions to be processed simultaneously, increasing throughput and speeding up execution.'
        },
        {
          'questionText': 'Which hazard occurs when an instruction depends on the result of a previous instruction that has not yet completed?',
          'options': ['Structural hazard', 'Data hazard', 'Control hazard', 'Memory hazard'],
          'correctAnswer': 'Data hazard',
          'explanation': 'A data hazard occurs when there is a dependency between instructions, such as one instruction needing the result of a prior instruction.'
        },
        {
          'questionText': 'Which type of pipeline hazard is caused by branch instructions?',
          'options': ['Data hazard', 'Control hazard', 'Structural hazard', 'Memory hazard'],
          'correctAnswer': 'Control hazard',
          'explanation': 'Control hazards arise from branch instructions because the pipeline may need to stall or flush if the branch prediction is incorrect.'
        },
        {
          'questionText': 'Which unit is responsible for decoding instructions in a CPU?',
          'options': ['ALU', 'Control Unit', 'Register File', 'Instruction Cache'],
          'correctAnswer': 'Control Unit',
          'explanation': 'The Control Unit decodes instructions and generates control signals to execute them.'
        },
        {
          'questionText': 'In a 5-stage instruction pipeline, which stage fetches the instruction from memory?',
          'options': ['Decode Stage', 'Execute Stage', 'Write-Back Stage', 'Fetch Stage'],
          'correctAnswer': 'Fetch Stage',
          'explanation': 'The Fetch Stage retrieves the instruction from memory using the Program Counter.'
        },
        {
          'questionText': 'Which component of the CPU is responsible for controlling data transfer within the processor?',
          'options': ['Memory Unit', 'ALU', 'Control Unit', 'Data Bus'],
          'correctAnswer': 'Control Unit',
          'explanation': 'The Control Unit manages data flow between the CPU components, such as the ALU, registers, and memory.'
        },
        {
          'questionText': 'What is the primary function of the register file in a CPU?',
          'options': ['Store frequently used data for quick access', 'Control instruction execution', 'Manage power consumption', 'Handle I/O operations'],
          'correctAnswer': 'Store frequently used data for quick access',
          'explanation': 'The register file holds operands and intermediate results for quick access during computation.'
        },
        {
          'questionText': 'Which of the following is a method used to handle pipeline hazards?',
          'options': ['Operand Forwarding', 'Memory Segmentation', 'Disk Caching', 'Bus Arbitration'],
          'correctAnswer': 'Operand Forwarding',
          'explanation': 'Operand Forwarding reduces data hazards by passing results directly to dependent instructions without waiting for write-back.'
        },
        {
          'questionText': 'What is the main disadvantage of pipelining?',
          'options': ['Increases processing speed', 'Reduces CPU complexity', 'Introduces pipeline hazards', 'Eliminates branch instructions'],
          'correctAnswer': 'Introduces pipeline hazards',
          'explanation': 'Pipelining can introduce hazards (data, control, structural), which may cause stalls or incorrect execution if not handled properly.'
        },
        {
          'questionText': 'Which of the following is NOT a pipeline stage in an instruction cycle?',
          'options': ['Fetch', 'Decode', 'Print', 'Execute'],
          'correctAnswer': 'Print',
          'explanation': 'Print is not a stage in the instruction pipeline; typical stages include Fetch, Decode, Execute, Memory Access, and Write-Back.'
        },
        {
          'questionText': 'What is the purpose of instruction pipelining in modern processors?',
          'options': ['Execute multiple instructions at the same time', 'Store more data in memory', 'Improve cache performance', 'Reduce the size of the processor'],
          'correctAnswer': 'Execute multiple instructions at the same time',
          'explanation': 'Pipelining allows overlapping execution of instructions, improving throughput.'
        },
        {
          'questionText': 'Which of the following is an advantage of pipelining?',
          'options': ['Increases CPU cycle time', 'Reduces instruction execution time', 'Increases latency', 'Reduces power consumption'],
          'correctAnswer': 'Reduces instruction execution time',
          'explanation': 'By overlapping instruction execution, pipelining effectively reduces the average time per instruction.'
        },
        {
          'questionText': 'Which of the following is a technique used to improve pipeline efficiency?',
          'options': ['Branch Prediction', 'Cache Mapping', 'Virtual Memory', 'Page Replacement'],
          'correctAnswer': 'Branch Prediction',
          'explanation': 'Branch Prediction reduces control hazards by guessing the outcome of branch instructions, minimizing pipeline stalls.'
        },
        {
          'questionText': 'Which pipeline hazard occurs when two instructions require the same hardware resource at the same time?',
          'options': ['Data hazard', 'Control hazard', 'Structural hazard', 'Memory hazard'],
          'correctAnswer': 'Structural hazard',
          'explanation': 'Structural hazards occur when hardware resources (e.g., memory or ALU) are insufficient to support simultaneous instruction execution.'
        }
      ],

      'COA_Module 3_Mock Test 2': [
        {
          'questionText': 'Which type of instruction causes control hazards in a pipeline?',
          'options': ['Arithmetic Instructions', 'Logical Instructions', 'Branch Instructions', 'Load Instructions'],
          'correctAnswer': 'Branch Instructions',
          'explanation': 'Branch instructions cause control hazards because they may change the program counter, potentially stalling the pipeline.'
        },
        {
          'questionText': 'What is the purpose of operand forwarding in a pipeline?',
          'options': ['Improve branch prediction', 'Reduce data hazards', 'Increase cache performance', 'Reduce memory usage'],
          'correctAnswer': 'Reduce data hazards',
          'explanation': 'Operand forwarding bypasses the write-back stage to provide results directly to dependent instructions, reducing data hazards.'
        },
        {
          'questionText': 'Which technique can be used to minimize branch penalties in pipelining?',
          'options': ['Delayed Branching', 'Cache Replacement', 'Register Indirect Addressing', 'Memory Segmentation'],
          'correctAnswer': 'Delayed Branching',
          'explanation': 'Delayed Branching executes instructions after a branch before taking the branch, reducing the penalty of misprediction.'
        },
        {
          'questionText': 'Which component   component is responsible for executing arithmetic and logical operations in a CPU?',
          'options': ['Control Unit', 'ALU', 'Register File', 'Cache Memory'],
          'correctAnswer': 'ALU',
          'explanation': 'The ALU performs arithmetic (e.g., addition) and logical (e.g., AND) operations in the CPU.'
        },
        {
          'questionText': 'Which of the following is NOT a type of pipeline hazard?',
          'options': ['Data hazard', 'Control hazard', 'Memory hazard', 'Process hazard'],
          'correctAnswer': 'Process hazard',
          'explanation': 'Data, control, and structural hazards are common pipeline hazards; "process hazard" is not a standard term in this context.'
        },
        {
          'questionText': 'Which of the following is NOT a function of the control unit?',
          'options': ['Fetching instructions from memory', 'Decoding instructions', 'Executing arithmetic operations', 'Generating control signals'],
          'correctAnswer': 'Executing arithmetic operations',
          'explanation': 'The control unit manages instruction flow but does not execute arithmetic operations; that is the ALU’s role.'
        },
        {
          'questionText': 'Which component in the CPU holds intermediate results during computation?',
          'options': ['Program Counter', 'Instruction Register', 'Accumulator', 'Control Unit'],
          'correctAnswer': 'Accumulator',
          'explanation': 'The accumulator temporarily holds intermediate results during computation in the CPU.'
        },
        {
          'questionText': 'What is the major advantage of pipelining in processors?',
          'options': ['Reduces power consumption', 'Increases the instruction execution rate', 'Increases memory access time', 'Eliminates the need for registers'],
          'correctAnswer': 'Increases the instruction execution rate',
          'explanation': 'Pipelining increases throughput by allowing multiple instructions to be processed concurrently.'
        },
        {
          'questionText': 'Which of the following best describes instruction pipelining?',
          'options': ['Executing multiple instructions at the same time', 'Dividing the execution of an instruction into stages', 'Storing frequently used data', 'Fetching instructions faster'],
          'correctAnswer': 'Dividing the execution of an instruction into stages',
          'explanation': 'Instruction pipelining breaks down instruction execution into stages (e.g., Fetch, Decode, Execute) to overlap processing.'
        },
        {
          'questionText': 'What type of hazard occurs due to dependencies between instructions in a pipeline?',
          'options': ['Data hazard', 'Structural hazard', 'Control hazard', 'Memory hazard'],
          'correctAnswer': 'Data hazard',
          'explanation': 'Data hazards occur when an instruction depends on the result of a previous instruction that hasn’t completed.'
        },
        {
          'questionText': 'Which technique is used to reduce branch hazards in pipelining?',
          'options': ['Operand forwarding', 'Delayed branching', 'Cache memory', 'Prefetching'],
          'correctAnswer': 'Delayed branching',
          'explanation': 'Delayed branching reduces branch hazards by executing instructions in the delay slot before the branch takes effect.'
        },
        {
          'questionText': 'In a pipeline, what is the purpose of the write-back stage?',
          'options': ['Decode the instruction', 'Execute the instruction', 'Store the result in registers', 'Fetch the instruction from memory'],
          'correctAnswer': 'Store the result in registers',
          'explanation': 'The write-back stage writes the result of an instruction back to the register file.'
        },
        {
          'questionText': 'Which register keeps track of the next instruction to be executed?',
          'options': ['Instruction Register', 'Stack Pointer', 'Program Counter', 'Memory Address Register'],
          'correctAnswer': 'Program Counter',
          'explanation': 'The Program Counter (PC) holds the address of the next instruction to be fetched and executed.'
        },
        {
          'questionText': 'Which of the following can be used to reduce data hazards in a pipeline?',
          'options': ['Cache memory', 'Operand forwarding', 'Register renaming', 'Memory segmentation'],
          'correctAnswer': 'Operand forwarding',
          'explanation': 'Operand forwarding provides data directly to dependent instructions, reducing delays caused by data hazards.'
        },
        {
          'questionText': 'What happens if a pipeline encounters a branch instruction?',
          'options': ['The pipeline executes it immediately', 'The pipeline may stall', 'The instruction is skipped', 'The pipeline speed increases'],
          'correctAnswer': 'The pipeline may stall',
          'explanation': 'A branch instruction may cause the pipeline to stall if the branch outcome is not predicted correctly, requiring a flush.'
        }
      ],
      'COA_Module 4_Mock Test 1': [
        {
          'questionText': 'Which type of memory is directly accessible by the CPU?',
          'options': ['Hard Disk', 'RAM', 'Flash Memory', 'Optical Disk'],
          'correctAnswer': 'RAM',
          'explanation': 'RAM (Random Access Memory) is the main memory directly accessible by the CPU for executing instructions and storing data temporarily.'
        },
        {
          'questionText': 'What is the purpose of cache memory?',
          'options': ['Store frequently accessed data for faster retrieval', 'Increase the size of main memory', 'Reduce power consumption', 'Act as a backup for secondary storage'],
          'correctAnswer': 'Store frequently accessed data for faster retrieval',
          'explanation': 'Cache memory stores frequently accessed data to reduce the time it takes for the CPU to retrieve it, improving performance.'
        },
        {
          'questionText': 'Which of the following is a non-volatile memory?',
          'options': ['RAM', 'ROM', 'Cache Memory', 'Registers'],
          'correctAnswer': 'ROM',
          'explanation': 'ROM (Read-Only Memory) is non-volatile, meaning it retains data even when the power is turned off, unlike RAM or cache.'
        },
        {
          'questionText': 'Which memory is used to store the BIOS in a computer?',
          'options': ['RAM', 'Hard Disk', 'ROM', 'Cache Memory'],
          'correctAnswer': 'ROM',
          'explanation': 'The BIOS (Basic Input/Output System) is stored in ROM, typically in a type called EEPROM or Flash ROM, as it needs to be retained without power.'
        },
        {
          'questionText': 'Which of the following is the fastest memory in a computer system?',
          'options': ['Hard Disk', 'RAM', 'Cache Memory', 'Optical Disk'],
          'correctAnswer': 'Cache Memory',
          'explanation': 'Cache memory is the fastest because it is located closest to the CPU and uses SRAM, which has very low access times.'
        },
        {
          'questionText': 'Virtual memory is used to:',
          'options': ['Store frequently used instructions', 'Increase the apparent size of RAM', 'Reduce CPU execution time', 'Store data permanently'],
          'correctAnswer': 'Increase the apparent size of RAM',
          'explanation': 'Virtual memory extends the physical RAM by using a portion of the hard disk as temporary storage, allowing larger programs to run.'
        },
        {
          'questionText': 'Which of the following memory types is the largest in terms of storage capacity?',
          'options': ['RAM', 'Cache Memory', 'Hard Disk', 'ROM'],
          'correctAnswer': 'Hard Disk',
          'explanation': 'Hard disks have the largest storage capacity among these options, often measured in terabytes, compared to RAM or cache.'
        },
        {
          'questionText': 'Which of the following is a characteristic of DRAM (Dynamic RAM)?',
          'options': ['Does not require refreshing', 'Requires constant refreshing', 'Faster than SRAM', 'Used as cache memory'],
          'correctAnswer': 'Requires constant refreshing',
          'explanation': 'DRAM needs to be refreshed periodically because it stores data in capacitors, which lose charge over time.'
        },
        {
          'questionText': 'Which type of memory is used for high-speed access in the CPU?',
          'options': ['ROM', 'Virtual Memory', 'Cache Memory', 'Hard Disk'],
          'correctAnswer': 'Cache Memory',
          'explanation': 'Cache memory, typically made of SRAM, is used for high-speed access by the CPU to store frequently accessed data.'
        },
        {
          'questionText': 'The time taken to access a memory location is called:',
          'options': ['Seek Time', 'Latency Time', 'Access Time', 'Fetch Time'],
          'correctAnswer': 'Access Time',
          'explanation': 'Access time is the time taken to locate and retrieve data from a memory location.'
        },
        {
          'questionText': 'The memory unit that communicates directly with the CPU is:',
          'options': ['Secondary Memory', 'Cache Memory', 'Main Memory', 'Virtual Memory'],
          'correctAnswer': 'Main Memory',
          'explanation': 'Main memory (RAM) communicates directly with the CPU for instruction execution and data storage, though cache sits between them for speed.'
        },
        {
          'questionText': 'Which of the following is a characteristic of SRAM (Static RAM)?',
          'options': ['Requires refreshing', 'Slower than DRAM', 'Faster but more expensive than DRAM', 'Used for long-term storage'],
          'correctAnswer': 'Faster but more expensive than DRAM',
          'explanation': 'SRAM does not require refreshing, is faster than DRAM, and is more expensive, making it suitable for cache memory.'
        },
        {
          'questionText': 'Which replacement policy is commonly used in cache memory?',
          'options': ['FIFO', 'LRU (Least Recently Used)', 'Round Robin', 'Random Replacement'],
          'correctAnswer': 'LRU (Least Recently Used)',
          'explanation': 'LRU replaces the least recently used cache line to make room for new data, improving cache efficiency.'
        },
        {
          'questionText': 'Which type of memory is erased when power is turned off?',
          'options': ['ROM', 'Flash Memory', 'RAM', 'EEPROM'],
          'correctAnswer': 'RAM',
          'explanation': 'RAM is volatile memory and loses its contents when the power is turned off, unlike ROM or Flash Memory.'
        },
        {
          'questionText': 'Which of the following is NOT a type of cache memory mapping?',
          'options': ['Direct Mapping', 'Associative Mapping', 'Set-Associative Mapping', 'Virtual Mapping'],
          'correctAnswer': 'Virtual Mapping',
          'explanation': 'Direct, Associative, and Set-Associative are standard cache mapping techniques; Virtual Mapping is not a recognized cache mapping type.'
        }
      ],

      'COA_Module 4_Mock Test 2': [
        {
          'questionText': 'Which memory technique allows multiple processes to run simultaneously by extending physical memory?',
          'options': ['Paging', 'Cache Mapping', 'Flash Storage', 'Register Allocation'],
          'correctAnswer': 'Paging',
          'explanation': 'Paging is used in virtual memory systems to divide memory into fixed-size pages, allowing multiple processes to share physical memory.'
        },
        {
          'questionText': 'Which of the following is NOT a primary storage device?',
          'options': ['Hard Disk', 'RAM', 'Cache Memory', 'Registers'],
          'correctAnswer': 'Hard Disk',
          'explanation': 'Hard Disk is a secondary storage device, while RAM, Cache Memory, and Registers are primary storage devices.'
        },
        {
          'questionText': 'What does the term ‘hit ratio’ refer to in cache memory?',
          'options': ['The number of times the CPU accesses RAM', 'The percentage of memory accesses satisfied by the cache', 'The delay in accessing memory', 'The speed of the memory'],
          'correctAnswer': 'The percentage of memory accesses satisfied by the cache',
          'explanation': 'Hit ratio measures the effectiveness of cache memory by calculating the percentage of memory accesses that find data in the cache.'
        },
        {
          'questionText': 'Which type of memory is used for temporary data storage in a CPU?',
          'options': ['Hard Disk', 'Registers', 'Optical Disk', 'Magnetic Tape'],
          'correctAnswer': 'Registers',
          'explanation': 'Registers are the fastest memory in the CPU and are used for temporary storage of data during processing.'
        },
        {
          'questionText': 'What is the main advantage of using virtual memory?',
          'options': ['Faster data processing', 'More efficient CPU utilization', 'Increased storage capacity', 'Cost reduction'],
          'correctAnswer': 'More efficient CPU utilization',
          'explanation': 'Virtual memory allows better multitasking and memory management, improving CPU utilization by enabling larger programs to run.'
        },
        {
          'questionText': 'Which type of memory is used as buffer storage between RAM and CPU?',
          'options': ['Hard Disk', 'Cache Memory', 'ROM', 'Registers'],
          'correctAnswer': 'Cache Memory',
          'explanation': 'Cache memory acts as a high-speed buffer between the CPU and RAM to reduce access time for frequently used data.'
        },
        {
          'questionText': 'Which of the following is the slowest memory?',
          'options': ['Cache Memory', 'RAM', 'Hard Disk', 'Registers'],
          'correctAnswer': 'Hard Disk',
          'explanation': 'Hard Disks are the slowest due to mechanical components and longer access times compared to electronic memory like RAM or cache.'
        },
        {
          'questionText': 'Which memory storage technique is used to prevent fragmentation?',
          'options': ['Paging', 'Segmentation', 'Virtual Memory', 'Direct Mapping'],
          'correctAnswer': 'Paging',
          'explanation': 'Paging divides memory into fixed-size pages, preventing external fragmentation by allocating memory non-contiguously.'
        },
        {
          'questionText': 'Which memory stores the bootloader of an operating system?',
          'options': ['Cache Memory', 'ROM', 'RAM', 'Hard Disk'],
          'correctAnswer': 'ROM',
          'explanation': 'The bootloader is typically stored in ROM (e.g., Flash ROM) as it needs to be available when the system starts.'
        },
        {
          'questionText': 'The process of transferring data between cache and main memory is called:',
          'options': ['Caching', 'Paging', 'Swapping', 'Memory Mapping'],
          'correctAnswer': 'Caching',
          'explanation': 'Caching refers to the process of transferring frequently used data between cache and main memory to speed up access.'
        },
        {
          'questionText': 'Which of the following uses magnetic storage technology?',
          'options': ['RAM', 'Hard Disk', 'Cache Memory', 'Flash Drive'],
          'correctAnswer': 'Hard Disk',
          'explanation': 'Hard Disks use magnetic storage to store data on spinning platters, unlike RAM or cache which are electronic.'
        },
        {
          'questionText': 'Which memory stores frequently used instructions for quick access?',
          'options': ['Virtual Memory', 'RAM', 'Cache Memory', 'Hard Disk'],
          'correctAnswer': 'Cache Memory',
          'explanation': 'Cache memory is designed to store frequently used instructions and data to reduce access time for the CPU.'
        },
        {
          'questionText': 'Which of the following is a disadvantage of DRAM compared to SRAM?',
          'options': ['Higher power consumption', 'Slower access time', 'More expensive', 'Requires more storage space'],
          'correctAnswer': 'Slower access time',
          'explanation': 'DRAM has slower access time than SRAM because it requires periodic refreshing, which introduces delays.'
        },
        {
          'questionText': 'Which term describes the process of copying data from the main memory to cache memory?',
          'options': ['Swapping', 'Fetching', 'Cache Write-back', 'Memory Mapping'],
          'correctAnswer': 'Fetching',
          'explanation': 'Fetching refers to the process of copying data from main memory to cache memory when needed by the CPU.'
        },
        {
          'questionText': 'Which memory stores system BIOS permanently?',
          'options': ['RAM', 'ROM', 'Cache Memory', 'Hard Disk'],
          'correctAnswer': 'ROM',
          'explanation': 'The BIOS is stored in ROM (often EEPROM or Flash ROM) to ensure it remains available even when the system is powered off.'
        }
      ],
      'COA_Module 5_Mock Test 1': [
        {
          'questionText': 'Which of the following is an input device?',
          'options': ['Printer', 'Monitor', 'Keyboard', 'Speaker'],
          'correctAnswer': 'Keyboard',
          'explanation': 'A keyboard is an input device used to send data (e.g., text) to the computer, whereas the others are output devices.'
        },
        {
          'questionText': 'Which I/O technique requires the CPU to continuously check the status of an I/O device?',
          'options': ['Programmed I/O', 'Interrupt-driven I/O', 'Direct Memory Access (DMA)', 'Memory-Mapped I/O'],
          'correctAnswer': 'Programmed I/O',
          'explanation': 'Programmed I/O (or polling) requires the CPU to repeatedly check the status of the I/O device, which can be inefficient.'
        },
        {
          'questionText': 'Which I/O technique allows data transfer without CPU intervention?',
          'options': ['Polling', 'Programmed I/O', 'Direct Memory Access (DMA)', 'Isolated I/O'],
          'correctAnswer': 'Direct Memory Access (DMA)',
          'explanation': 'DMA allows data to be transferred directly between memory and I/O devices without CPU involvement, reducing CPU workload.'
        },
        {
          'questionText': 'Which device manages multiple interrupt requests from different devices?',
          'options': ['DMA Controller', 'Interrupt Controller', 'I/O Processor', 'Memory Manager'],
          'correctAnswer': 'Interrupt Controller',
          'explanation': 'An Interrupt Controller (e.g., PIC) prioritizes and manages multiple interrupt requests from devices to the CPU.'
        },
        {
          'questionText': 'Which type of I/O uses a dedicated processor to handle I/O operations?',
          'options': ['Programmed I/O', 'Interrupt-driven I/O', 'Direct Memory Access (DMA)', 'I/O Processor (IOP)'],
          'correctAnswer': 'I/O Processor (IOP)',
          'explanation': 'An I/O Processor (IOP) is a dedicated processor that handles I/O operations independently, offloading the main CPU.'
        },
        {
          'questionText': 'What is the function of an I/O controller?',
          'options': ['Perform arithmetic operations', 'Manage data transfer between CPU and peripherals', 'Store data permanently', 'Control power distribution in the system'],
          'correctAnswer': 'Manage data transfer between CPU and peripherals',
          'explanation': 'The I/O controller manages communication and data transfer between the CPU and peripheral devices.'
        },
        {
          'questionText': 'Which type of memory is used to store input and output data temporarily?',
          'options': ['Registers', 'Cache', 'Buffer', 'ROM'],
          'correctAnswer': 'Buffer',
          'explanation': 'Buffers are used to temporarily store data during I/O operations to match the speed between devices and the CPU.'
        },
        {
          'questionText': 'Which bus is used to connect the CPU with I/O devices?',
          'options': ['Address Bus', 'Data Bus', 'Peripheral Bus', 'Expansion Bus'],
          'correctAnswer': 'Peripheral Bus',
          'explanation': 'The Peripheral Bus (e.g., PCI or USB) connects I/O devices to the CPU for communication and data transfer.'
        },
        {
          'questionText': 'Which of the following is a character-based I/O device?',
          'options': ['Hard Disk', 'Keyboard', 'DVD Drive', 'Monitor'],
          'correctAnswer': 'Keyboard',
          'explanation': 'A keyboard is a character-based device, as it sends individual characters as input, unlike block devices like hard disks.'
        },
        {
          'questionText': 'Which type of I/O uses separate address spaces for memory and I/O devices?',
          'options': ['Memory-Mapped I/O', 'Isolated I/O', 'Direct Memory Access (DMA)', 'Interrupt-driven I/O'],
          'correctAnswer': 'Isolated I/O',
          'explanation': 'Isolated I/O uses separate address spaces for I/O devices and memory, requiring special I/O instructions.'
        },
        {
          'questionText': 'Which of the following is an example of a block device?',
          'options': ['Keyboard', 'Hard Disk', 'Mouse', 'Printer'],
          'correctAnswer': 'Hard Disk',
          'explanation': 'A hard disk is a block device, as it transfers data in fixed-size blocks, unlike character devices like keyboards.'
        },
        {
          'questionText': 'Which protocol is commonly used for serial communication between microprocessors and I/O devices?',
          'options': ['SPI', 'HTTP', 'FTP', 'TCP/IP'],
          'correctAnswer': 'SPI',
          'explanation': 'SPI (Serial Peripheral Interface) is a common protocol for serial communication between microprocessors and peripherals.'
        },
        {
          'questionText': 'What is the function of a device driver?',
          'options': ['Manage CPU execution cycles', 'Control the execution of arithmetic operations', 'Facilitate communication between OS and hardware devices', 'Manage cache memory'],
          'correctAnswer': 'Facilitate communication between OS and hardware devices',
          'explanation': 'A device driver acts as an intermediary, allowing the operating system to communicate with hardware devices.'
        },
        {
          'questionText': 'Which of the following is NOT an example of an output device?',
          'options': ['Printer', 'Scanner', 'Monitor', 'Speaker'],
          'correctAnswer': 'Scanner',
          'explanation': 'A scanner is an input device, as it sends data to the computer, while the others are output devices.'
        },
        {
          'questionText': 'Which I/O method requires continuous CPU involvement?',
          'options': ['Programmed I/O', 'Interrupt-driven I/O', 'Direct Memory Access (DMA)', 'I/O Processor (IOP)'],
          'correctAnswer': 'Programmed I/O',
          'explanation': 'Programmed I/O requires the CPU to actively manage the I/O process, continuously checking device status.'
        }
      ],

      'COA_Module 5_Mock Test 2': [
        {
          'questionText': 'Which bus transfers control signals between the CPU and I/O devices?',
          'options': ['Data Bus', 'Control Bus', 'Address Bus', 'Expansion Bus'],
          'correctAnswer': 'Control Bus',
          'explanation': 'The Control Bus carries control signals (e.g., read/write signals) between the CPU and I/O devices to manage operations.'
        },
        {
          'questionText': 'Which of the following is NOT a type of interrupt?',
          'options': ['Hardware Interrupt', 'Software Interrupt', 'Virtual Interrupt', 'External Interrupt'],
          'correctAnswer': 'Virtual Interrupt',
          'explanation': 'Hardware, software, and external interrupts are standard types; "virtual interrupt" is not a recognized interrupt type.'
        },
        {
          'questionText': 'Which I/O method provides the fastest data transfer?',
          'options': ['Programmed I/O', 'Interrupt-driven I/O', 'Direct Memory Access (DMA)', 'Memory-Mapped I/O'],
          'correctAnswer': 'Direct Memory Access (DMA)',
          'explanation': 'DMA provides the fastest data transfer by allowing direct memory access without CPU intervention.'
        },
        {
          'questionText': 'What is the primary function of an interrupt?',
          'options': ['Speed up memory access', 'Notify the CPU of an event', 'Store temporary data', 'Manage cache operations'],
          'correctAnswer': 'Notify the CPU of an event',
          'explanation': 'An interrupt signals the CPU about an event (e.g., I/O completion or error) that requires immediate attention.'
        },
        {
          'questionText': 'Which type of interrupt occurs due to external events like keyboard input?',
          'options': ['Software Interrupt', 'Hardware Interrupt', 'Internal Interrupt', 'Stack Overflow Interrupt'],
          'correctAnswer': 'Hardware Interrupt',
          'explanation': 'Hardware interrupts are triggered by external events, such as a keyboard press or a signal from a peripheral device.'
        },
        {
          'questionText': 'Which of the following uses memory-mapped I/O?',
          'options': ['Hard Disk', 'Keyboard', 'CPU Registers', 'RAM'],
          'correctAnswer': 'CPU Registers',
          'explanation': 'Memory-mapped I/O maps I/O device registers into the CPU’s memory address space, often used for CPU registers.'
        },
        {
          'questionText': 'Which I/O technique reduces CPU workload by transferring data in bulk?',
          'options': ['Polling', 'Interrupt-driven I/O', 'DMA', 'Programmed I/O'],
          'correctAnswer': 'DMA',
          'explanation': 'DMA reduces CPU workload by handling bulk data transfers directly between memory and I/O devices.'
        },
        {
          'questionText': 'Which of the following devices is an example of a serial communication interface?',
          'options': ['PCIe', 'USB', 'IDE', 'SATA'],
          'correctAnswer': 'USB',
          'explanation': 'USB (Universal Serial Bus) is a widely used serial communication interface for connecting devices.'
        },
        {
          'questionText': 'Which component is responsible for handling multiple simultaneous I/O requests?',
          'options': ['CPU', 'I/O Controller', 'Memory Controller', 'DMA Controller'],
          'correctAnswer': 'I/O Controller',
          'explanation': 'The I/O Controller manages multiple I/O requests, ensuring proper communication between devices and the CPU.'
        },
        {
          'questionText': 'Which register holds the address of the next I/O operation?',
          'options': ['Memory Address Register', 'I/O Address Register', 'Data Register', 'Stack Pointer'],
          'correctAnswer': 'I/O Address Register',
          'explanation': 'The I/O Address Register holds the address of the next I/O operation to be performed by the device.'
        },
        {
          'questionText': 'What is the purpose of an I/O buffer?',
          'options': ['Increase CPU speed', 'Store data temporarily before transfer', 'Control memory access', 'Improve bus performance'],
          'correctAnswer': 'Store data temporarily before transfer',
          'explanation': 'An I/O buffer temporarily stores data to compensate for speed differences between the CPU and I/O devices.'
        },
        {
          'questionText': 'Which I/O operation method uses a single memory space for both I/O devices and system memory?',
          'options': ['Memory-Mapped I/O', 'Isolated I/O', 'Direct Memory Access (DMA)', 'Bus Arbitration'],
          'correctAnswer': 'Memory-Mapped I/O',
          'explanation': 'Memory-Mapped I/O uses a single address space for both memory and I/O devices, simplifying communication.'
        },
        {
          'questionText': 'What is the purpose of handshaking in I/O operations?',
          'options': ['Error detection', 'Synchronization between sender and receiver', 'Increase data storage capacity', 'Control CPU execution'],
          'correctAnswer': 'Synchronization between sender and receiver',
          'explanation': 'Handshaking ensures proper synchronization between the sender and receiver during data transfer to prevent data loss.'
        },
        {
          'questionText': 'Which bus is used for communication between the processor and I/O devices?',
          'options': ['Address Bus', 'Data Bus', 'Control Bus', 'Peripheral Bus'],
          'correctAnswer': 'Peripheral Bus',
          'explanation': 'The Peripheral Bus (e.g., USB or PCIe) facilitates communication between the processor and I/O devices.'
        },
        {
          'questionText': 'Which I/O operation method introduces a delay to prevent data loss?',
          'options': ['Interrupt-driven I/O', 'Polling', 'Direct Memory Access (DMA)', 'Handshaking'],
          'correctAnswer': 'Handshaking',
          'explanation': 'Handshaking introduces delays to ensure the sender and receiver are synchronized, preventing data loss during transfer.'
        }
      ],
      // OS Subject
      'OS_Module 1_Mock Test 1': [
        {
          'questionText': 'What is the main goal of an operating system?',
          'options': ['To provide an environment for software execution', 'To boost hardware speed', 'To enhance application features', 'To eliminate errors'],
          'correctAnswer': 'To provide an environment for software execution',
          'explanation': 'The primary purpose of an OS is to create a platform where software can run and interact with hardware.'
        },
        {
          'questionText': 'Which of these is NOT considered a type of operating system?',
          'options': ['Real-time OS', 'Distributed OS', 'Compiler-based OS', 'Embedded OS'],
          'correctAnswer': 'Compiler-based OS',
          'explanation': 'A compiler is a software tool, not a type of OS; the others are valid OS categories.'
        },
        {
          'questionText': 'Which software is an example of system software?',
          'options': ['MS Word', 'Windows OS', 'Google Chrome', 'Adobe Photoshop'],
          'correctAnswer': 'Windows OS',
          'explanation': 'System software, like Windows OS, manages hardware and provides a platform for applications.'
        },
        {
          'questionText': 'Which component of the OS communicates directly with hardware?',
          'options': ['Shell', 'Kernel', 'GUI', 'User applications'],
          'correctAnswer': 'Kernel',
          'explanation': 'The kernel is the core of the OS that interacts directly with hardware.'
        },
        {
          'questionText': 'Which OS type is built for handling real-time tasks?',
          'options': ['Multiprocessing OS', 'Batch OS', 'Real-Time OS', 'Distributed OS'],
          'correctAnswer': 'Real-Time OS',
          'explanation': 'Real-Time OS is designed to process tasks with strict timing requirements.'
        },
        {
          'questionText': 'Which operating system supports multiple users simultaneously?',
          'options': ['MS-DOS', 'Windows 7', 'UNIX', 'Android'],
          'correctAnswer': 'UNIX',
          'explanation': 'UNIX is a multi-user OS, allowing multiple users to work concurrently.'
        },
        {
          'questionText': 'Which interface uses text commands to interact with the OS?',
          'options': ['GUI', 'CLI', 'Touch UI', 'API'],
          'correctAnswer': 'CLI',
          'explanation': 'The Command Line Interface (CLI) enables text-based interaction with the OS.'
        },
        {
          'questionText': 'Which task is NOT typically performed by an OS?',
          'options': ['Memory management', 'File management', 'Networking services', 'Internet browsing'],
          'correctAnswer': 'Internet browsing',
          'explanation': 'Internet browsing is an application-level task, not a core OS function.'
        },
        {
          'questionText': 'What is the role of a system call in an OS?',
          'options': ['To execute user programs', 'To request services from the OS', 'To reboot the system', 'To run background tasks'],
          'correctAnswer': 'To request services from the OS',
          'explanation': 'System calls allow programs to request OS services like file access or memory allocation.'
        },
        {
          'questionText': 'Which of these is NOT a core component of an OS?',
          'options': ['Process management', 'Device drivers', 'Spreadsheet software', 'Memory management'],
          'correctAnswer': 'Spreadsheet software',
          'explanation': 'Spreadsheet software is an application, not an OS component.'
        },
        {
          'questionText': 'What term describes the OS’s speed in responding to an input?',
          'options': ['Response time', 'Turnaround time', 'Execution time', 'Context switch time'],
          'correctAnswer': 'Response time',
          'explanation': 'Response time measures how quickly the OS reacts to user or system input.'
        },
        {
          'questionText': 'Which OS is commonly used on mobile devices?',
          'options': ['Android', 'Windows XP', 'Linux Mint', 'FreeBSD'],
          'correctAnswer': 'Android',
          'explanation': 'Android is a widely used OS for mobile devices like smartphones and tablets.'
        },
        {
          'questionText': 'Which operating system is NOT open-source?',
          'options': ['Linux', 'Windows 10', 'FreeBSD', 'Ubuntu'],
          'correctAnswer': 'Windows 10',
          'explanation': 'Windows 10 is proprietary, unlike the open-source options Linux, FreeBSD, and Ubuntu.'
        },
        {
          'questionText': 'What does GUI stand for in the context of an OS?',
          'options': ['General User Interface', 'Graphical User Interface', 'Grouped User Interaction', 'Generalized User Interconnection'],
          'correctAnswer': 'Graphical User Interface',
          'explanation': 'GUI stands for Graphical User Interface, providing a visual way to interact with the OS.'
        },
        {
          'questionText': 'Which scheduling algorithm is ideal for time-sharing systems?',
          'options': ['FCFS', 'SJF', 'Round Robin', 'Priority Scheduling'],
          'correctAnswer': 'Round Robin',
          'explanation': 'Round Robin ensures fair CPU allocation in time-sharing systems by using time slices.'
        }
      ],
      'OS_Module 1_Mock Test 2': [
        {
          'questionText': 'Which layer of the OS is closest to the hardware?',
          'options': ['Application layer', 'User layer', 'Kernel', 'File system'],
          'correctAnswer': 'Kernel',
          'explanation': 'The kernel is the lowest layer of the OS, directly managing hardware resources.'
        },
        {
          'questionText': 'Which type of OS supports running multiple processes simultaneously?',
          'options': ['Single-tasking OS', 'Multi-tasking OS', 'Batch OS', 'None of the above'],
          'correctAnswer': 'Multi-tasking OS',
          'explanation': 'A multi-tasking OS allows multiple processes to execute concurrently.'
        },
        {
          'questionText': 'What is the function of the shell in an operating system?',
          'options': ['Manages hardware', 'Interfaces between user and kernel', 'Controls file system', 'Runs background services'],
          'correctAnswer': 'Interfaces between user and kernel',
          'explanation': 'The shell acts as a bridge, allowing users to communicate with the kernel.'
        },
        {
          'questionText': 'Which operating system is NOT derived from UNIX?',
          'options': ['Linux', 'MacOS', 'Windows', 'FreeBSD'],
          'correctAnswer': 'Windows',
          'explanation': 'Windows is not UNIX-based, unlike Linux, MacOS, and FreeBSD.'
        },
        {
          'questionText': 'What does multiprogramming refer to in an OS?',
          'options': ['Running multiple apps at once', 'Running one program at a time', 'Running OS services', 'Running multiple OSes'],
          'correctAnswer': 'Running multiple apps at once',
          'explanation': 'Multiprogramming allows multiple applications to reside in memory and execute concurrently.'
        },
        {
          'questionText': 'What is the main objective of a time-sharing system?',
          'options': ['Minimize response time', 'Maximize CPU usage', 'Reduce memory use', 'Eliminate system calls'],
          'correctAnswer': 'Minimize response time',
          'explanation': 'Time-sharing systems aim to reduce response time for multiple users.'
        },
        {
          'questionText': 'Which OS was created by Microsoft?',
          'options': ['UNIX', 'Linux', 'Windows', 'MacOS'],
          'correctAnswer': 'Windows',
          'explanation': 'Windows is a popular OS developed by Microsoft.'
        },
        {
          'questionText': 'Which OS type is typically used in aircraft control systems?',
          'options': ['Real-time OS', 'Batch OS', 'Multiprocessing OS', 'Network OS'],
          'correctAnswer': 'Real-time OS',
          'explanation': 'Real-time OS ensures timely processing, critical for systems like aircraft controls.'
        },
        {
          'questionText': 'What is the purpose of a device driver in an OS?',
          'options': ['Manages file permissions', 'Interfaces hardware and OS', 'Controls user accounts', 'Handles logs'],
          'correctAnswer': 'Interfaces hardware and OS',
          'explanation': 'Device drivers enable the OS to communicate with hardware devices.'
        },
        {
          'questionText': 'Which OS component handles process management?',
          'options': ['File system', 'Kernel', 'GUI', 'Memory manager'],
          'correctAnswer': 'Kernel',
          'explanation': 'The kernel manages processes, including their creation, scheduling, and termination.'
        },
        {
          'questionText': 'Which is an example of a batch operating system?',
          'options': ['Windows 10', 'MS-DOS', 'Android', 'Linux'],
          'correctAnswer': 'MS-DOS',
          'explanation': 'MS-DOS is a batch OS that processes tasks sequentially without user interaction.'
        },
        {
          'questionText': 'Which of these is NOT a typical OS feature?',
          'options': ['Multi-tasking', 'Process scheduling', 'User authentication', 'Data mining'],
          'correctAnswer': 'Data mining',
          'explanation': 'Data mining is an application-level task, not a core OS feature.'
        },
        {
          'questionText': 'What best defines an embedded OS?',
          'options': ['OS for servers', 'OS for networks', 'OS for specialized hardware', 'OS for general computing'],
          'correctAnswer': 'OS for specialized hardware',
          'explanation': 'Embedded OS is tailored for specific devices like appliances or IoT systems.'
        },
        {
          'questionText': 'What does virtual memory enable in an OS?',
          'options': ['Running programs without enough RAM', 'Boosting CPU speed', 'Malware protection', 'Improving UI'],
          'correctAnswer': 'Running programs without enough RAM',
          'explanation': 'Virtual memory uses disk space to extend RAM, allowing larger programs to run.'
        },
        {
          'questionText': 'Which allows command-based interaction with the OS?',
          'options': ['CLI', 'GUI', 'API', 'Device driver'],
          'correctAnswer': 'CLI',
          'explanation': 'The Command Line Interface (CLI) lets users issue text commands to the OS.'
        }
      ],
      'OS_Module 2_Mock Test 1': [
        {
          'questionText': 'What defines a process in an operating system?',
          'options': ['A program being executed', 'A block of memory', 'A single CPU instruction', 'A file on disk'],
          'correctAnswer': 'A program being executed',
          'explanation': 'A process is an active program in execution, managed by the OS.'
        },
        {
          'questionText': 'Which of these is NOT a valid process state?',
          'options': ['Running', 'Ready', 'Sleeping', 'Terminated'],
          'correctAnswer': 'Sleeping',
          'explanation': 'Sleeping is not a standard process state; typical states include Running, Ready, Blocked, and Terminated.'
        },
        {
          'questionText': 'What is stored in a Process Control Block (PCB)?',
          'options': ['Process metadata', 'Scheduling algorithms', 'Hardware details', 'System call logs'],
          'correctAnswer': 'Process metadata',
          'explanation': 'The PCB holds key info about a process, like its state, ID, and resource usage.'
        },
        {
          'questionText': 'Which component manages process scheduling?',
          'options': ['Memory Manager', 'CPU Scheduler', 'File Manager', 'Disk Controller'],
          'correctAnswer': 'CPU Scheduler',
          'explanation': 'The CPU Scheduler selects which process runs on the CPU next.'
        },
        {
          'questionText': 'Which algorithm prioritizes the shortest job for execution?',
          'options': ['Round Robin', 'Shortest Job Next', 'First-Come-First-Serve', 'Priority Scheduling'],
          'correctAnswer': 'Shortest Job Next',
          'explanation': 'Shortest Job Next (SJN) minimizes waiting time by executing the shortest job first.'
        },
        {
          'questionText': 'What is the primary role of a scheduler in an OS?',
          'options': ['Manages memory', 'Controls I/O devices', 'Picks processes to run', 'Handles file operations'],
          'correctAnswer': 'Picks processes to run',
          'explanation': 'A scheduler determines which process gets CPU time from the ready queue.'
        },
        {
          'questionText': 'Which scheduler moves processes from the ready queue to the CPU?',
          'options': ['Long-term scheduler', 'Short-term scheduler', 'Medium-term scheduler', 'Dispatcher'],
          'correctAnswer': 'Short-term scheduler',
          'explanation': 'The short-term scheduler assigns CPU time to processes in the ready state.'
        },
        {
          'questionText': 'What does context switching involve?',
          'options': ['Switching modes', 'Saving and restoring process state', 'Moving data to disk', 'Scheduling I/O'],
          'correctAnswer': 'Saving and restoring process state',
          'explanation': 'Context switching saves the current process’s state and loads another’s to switch execution.'
        },
        {
          'questionText': 'Which scheduling algorithm is non-preemptive?',
          'options': ['Round Robin', 'Shortest Remaining Time First', 'First-Come-First-Serve', 'Multi-Level Queue'],
          'correctAnswer': 'First-Come-First-Serve',
          'explanation': 'FCFS runs a process to completion before moving to the next, making it non-preemptive.'
        },
        {
          'questionText': 'Which algorithm uses time slices for process execution?',
          'options': ['FCFS', 'Round Robin', 'Shortest Job Next', 'Priority Scheduling'],
          'correctAnswer': 'Round Robin',
          'explanation': 'Round Robin allocates fixed time slices to each process in a cyclic order.'
        },
        {
          'questionText': 'What does the fork() system call accomplish?',
          'options': ['Creates a new process', 'Ends a process', 'Allocates memory', 'Runs a file'],
          'correctAnswer': 'Creates a new process',
          'explanation': 'fork() duplicates the calling process, creating a new child process.'
        },
        {
          'questionText': 'What happens when exec() is called?',
          'options': ['Spawns a process', 'Terminates a process', 'Replaces process with a new program', 'Reserves memory'],
          'correctAnswer': 'Replaces process with a new program',
          'explanation': 'exec() overwrites the current process image with a new program.'
        },
        {
          'questionText': 'Which process starts first in an operating system?',
          'options': ['User Process', 'System Daemon', 'Init Process', 'Kernel Thread'],
          'correctAnswer': 'Init Process',
          'explanation': 'The Init Process is the first user-level process started by the OS after boot.'
        },
        {
          'questionText': 'What state does a process enter while awaiting I/O?',
          'options': ['Ready', 'Running', 'Blocked', 'Terminated'],
          'correctAnswer': 'Blocked',
          'explanation': 'A process waiting for I/O is Blocked until the operation completes.'
        },
        {
          'questionText': 'What characterizes a zombie process?',
          'options': ['Terminated but still in process table', 'Overuses CPU', 'Deadlocked process', 'Crashed system'],
          'correctAnswer': 'Terminated but still in process table',
          'explanation': 'A zombie process has finished but awaits parent cleanup in the process table.'
        }
      ],
      'OS_Module 2_Mock Test 2': [
        {
          'questionText': 'What defines an orphan process?',
          'options': ['Child process with no parent', 'Process with no memory', 'Unschedulable process', 'CPU-heavy process'],
          'correctAnswer': 'Child process with no parent',
          'explanation': 'An orphan process’s parent terminates before it, leaving it parentless.'
        },
        {
          'questionText': 'Which OS component facilitates inter-process communication?',
          'options': ['CPU', 'Kernel', 'File System', 'RAM'],
          'correctAnswer': 'Kernel',
          'explanation': 'The kernel provides mechanisms like pipes and shared memory for IPC.'
        },
        {
          'questionText': 'Which of these is NOT a method for inter-process communication?',
          'options': ['Pipes', 'Message Passing', 'Shared Memory', 'Virtualization'],
          'correctAnswer': 'Virtualization',
          'explanation': 'Virtualization is about resource isolation, not IPC; the others are valid IPC methods.'
        },
        {
          'questionText': 'What is a key drawback of creating new processes?',
          'options': ['High CPU usage', 'Resource overhead', 'Faster execution', 'Improved security'],
          'correctAnswer': 'Resource overhead',
          'explanation': 'Process creation consumes significant system resources like memory and CPU.'
        },
        {
          'questionText': 'Which scheduling method avoids process starvation?',
          'options': ['FCFS', 'Round Robin', 'Priority Scheduling with Aging', 'Shortest Job Next'],
          'correctAnswer': 'Priority Scheduling with Aging',
          'explanation': 'Aging increases priority over time, ensuring all processes eventually run.'
        },
        {
          'questionText': 'What is the purpose of a daemon process?',
          'options': ['Runs user apps', 'Handles background tasks', 'Manages GUI', 'Controls bootloader'],
          'correctAnswer': 'Handles background tasks',
          'explanation': 'Daemon processes run in the background to provide system services.'
        },
        {
          'questionText': 'What occurs when a process ends?',
          'options': ['Removed from memory', 'Continues running', 'Blocks others', 'Enters waiting state'],
          'correctAnswer': 'Removed from memory',
          'explanation': 'A terminated process has its resources freed and is removed from memory.'
        },
        {
          'questionText': 'What is a process queue used for?',
          'options': ['Stores terminated processes', 'Holds processes awaiting execution', 'Manages disk I/O', 'Lists completed programs'],
          'correctAnswer': 'Holds processes awaiting execution',
          'explanation': 'A process queue organizes processes waiting for CPU time.'
        },
        {
          'questionText': 'Which OS employs preemptive scheduling?',
          'options': ['Windows', 'MS-DOS', 'Basic Batch Systems', 'IBM OS/360'],
          'correctAnswer': 'Windows',
          'explanation': 'Windows uses preemptive scheduling to interrupt and switch processes.'
        },
        {
          'questionText': 'What does multi-threading enhance?',
          'options': ['CPU utilization', 'Disk space', 'RAM speed', 'Network connectivity'],
          'correctAnswer': 'CPU utilization',
          'explanation': 'Multi-threading allows better CPU use by running multiple threads concurrently.'
        },
        {
          'questionText': 'What does process starvation mean?',
          'options': ['Waiting indefinitely for CPU', 'Overusing memory', 'Never terminating', 'Excessive I/O use'],
          'correctAnswer': 'Waiting indefinitely for CPU',
          'explanation': 'Starvation occurs when a process is perpetually denied CPU time.'
        },
        {
          'questionText': 'What is stored in a job queue?',
          'options': ['Processes awaiting execution', 'Terminated processes', 'Executed processes', 'Memory pages'],
          'correctAnswer': 'Processes awaiting execution',
          'explanation': 'A job queue holds processes waiting to be scheduled for execution.'
        },
        {
          'questionText': 'What characterizes a CPU-bound process?',
          'options': ['Heavy CPU use over I/O', 'Waiting for disk', 'Idle process', 'Kernel mode process'],
          'correctAnswer': 'Heavy CPU use over I/O',
          'explanation': 'CPU-bound processes require more computation than I/O operations.'
        },
        {
          'questionText': 'Which is NOT a criterion for process scheduling?',
          'options': ['Turnaround Time', 'Waiting Time', 'Cache Miss Rate', 'Response Time'],
          'correctAnswer': 'Cache Miss Rate',
          'explanation': 'Cache Miss Rate relates to hardware performance, not scheduling metrics.'
        },
        {
          'questionText': 'What is a thread in the context of an OS?',
          'options': ['A lightweight process', 'A memory unit', 'A disk scheduling method', 'A scheduling algorithm'],
          'correctAnswer': 'A lightweight process',
          'explanation': 'A thread is a smaller execution unit within a process, sharing its resources.'
        }
      ],
      'OS_Module 3_Mock Test 1': [
        {
          'questionText': 'What does process synchronization aim to achieve?',
          'options': ['Parallel process execution', 'Conflict-free process coordination', 'Reduced memory fragmentation', 'Faster process execution'],
          'correctAnswer': 'Conflict-free process coordination',
          'explanation': 'Process synchronization ensures processes access shared resources without conflicts.'
        },
        {
          'questionText': 'What issue is associated with the critical section?',
          'options': ['Multiple processes sharing resources', 'Excessive CPU usage', 'Memory deadlocks', 'File corruption'],
          'correctAnswer': 'Multiple processes sharing resources',
          'explanation': 'The critical section problem arises when multiple processes access shared resources concurrently.'
        },
        {
          'questionText': 'Which is NOT a requirement for managing critical sections?',
          'options': ['Mutual Exclusion', 'Progress', 'Starvation', 'Bounded Waiting'],
          'correctAnswer': 'Starvation',
          'explanation': 'Starvation is a problem to avoid, not a requirement; the others ensure proper critical section handling.'
        },
        {
          'questionText': 'What does mutual exclusion guarantee?',
          'options': ['Only one process in critical section at a time', 'No deadlocks occur', 'No memory fragmentation', 'Priority-based scheduling'],
          'correctAnswer': 'Only one process in critical section at a time',
          'explanation': 'Mutual exclusion prevents simultaneous access to a critical section by multiple processes.'
        },
        {
          'questionText': 'Which algorithm supports process synchronization?',
          'options': ['Peterson’s Algorithm', 'FIFO Algorithm', 'Round Robin Scheduling', 'Shortest Job Next'],
          'correctAnswer': 'Peterson’s Algorithm',
          'explanation': 'Peterson’s Algorithm ensures mutual exclusion and synchronization for two processes.'
        },
        {
          'questionText': 'Which mechanism is NOT used for synchronizing processes?',
          'options': ['Semaphores', 'Mutex', 'Paging', 'Monitors'],
          'correctAnswer': 'Paging',
          'explanation': 'Paging is a memory management technique, not a synchronization mechanism.'
        },
        {
          'questionText': 'What is a semaphore in the context of an OS?',
          'options': ['A variable for shared resource access', 'A scheduling algorithm', 'A process execution method', 'A memory management tool'],
          'correctAnswer': 'A variable for shared resource access',
          'explanation': 'A semaphore is a synchronization tool that controls access to shared resources.'
        },
        {
          'questionText': 'Which operations are associated with semaphores?',
          'options': ['Wait() and Signal()', 'Read() and Write()', 'Open() and Close()', 'Execute() and Terminate()'],
          'correctAnswer': 'Wait() and Signal()',
          'explanation': 'Wait() decrements and Signal() increments the semaphore to manage resource access.'
        },
        {
          'questionText': 'What is the starting value of a binary semaphore?',
          'options': ['0', '1', '-1', 'Any non-negative integer'],
          'correctAnswer': '1',
          'explanation': 'A binary semaphore starts at 1, representing an unlocked state.'
        },
        {
          'questionText': 'Which is NOT a recognized type of semaphore?',
          'options': ['Binary Semaphore', 'Counting Semaphore', 'Priority Semaphore', 'None of the above'],
          'correctAnswer': 'Priority Semaphore',
          'explanation': 'Priority Semaphore isn’t a standard type; Binary and Counting are the main categories.'
        },
        {
          'questionText': 'What issue can improper semaphore use cause?',
          'options': ['Race conditions', 'Faster CPU performance', 'Reduced execution time', 'Extra memory allocation'],
          'correctAnswer': 'Race conditions',
          'explanation': 'Incorrect semaphore use can lead to race conditions, where process outcomes depend on timing.'
        },
        {
          'questionText': 'Which synchronization tool operates within the kernel?',
          'options': ['Monitors', 'Mutex', 'Paging', 'Swapping'],
          'correctAnswer': 'Mutex',
          'explanation': 'A mutex is a kernel-level locking mechanism for ensuring mutual exclusion.'
        },
        {
          'questionText': 'What defines a monitor in process synchronization?',
          'options': ['A high-level synchronization construct', 'A scheduling algorithm', 'A memory partitioning method', 'A disk management tool'],
          'correctAnswer': 'A high-level synchronization construct',
          'explanation': 'Monitors provide a structured way to synchronize processes with mutual exclusion.'
        },
        {
          'questionText': 'What does the bounded buffer problem address?',
          'options': ['Producer-consumer synchronization', 'Multi-processing deadlocks', 'Paging and segmentation', 'CPU scheduling'],
          'correctAnswer': 'Producer-consumer synchronization',
          'explanation': 'It deals with synchronizing producer and consumer processes sharing a finite buffer.'
        },
        {
          'questionText': 'Which is an example of inter-process communication?',
          'options': ['Shared memory', 'File execution', 'Multitasking', 'Process termination'],
          'correctAnswer': 'Shared memory',
          'explanation': 'Shared memory allows processes to communicate by accessing the same memory region.'
        }
      ],
      'OS_Module 3_Mock Test 2': [
        {
          'questionText': 'What characterizes a deadlock in an OS?',
          'options': ['Processes waiting indefinitely for resources', 'A scheduling technique', 'Memory fragmentation', 'A disk algorithm'],
          'correctAnswer': 'Processes waiting indefinitely for resources',
          'explanation': 'A deadlock occurs when processes hold resources and wait for others, causing a standstill.'
        },
        {
          'questionText': 'Which condition is NOT required for a deadlock?',
          'options': ['Mutual Exclusion', 'Hold and Wait', 'Circular Wait', 'Preemption'],
          'correctAnswer': 'Preemption',
          'explanation': 'Preemption prevents deadlocks; the other three are necessary conditions for a deadlock.'
        },
        {
          'questionText': 'What does the circular wait condition mean?',
          'options': ['Processes waiting in a circular chain', 'Round-robin execution', 'Indefinite waiting', 'Queue of terminated processes'],
          'correctAnswer': 'Processes waiting in a circular chain',
          'explanation': 'Circular wait occurs when each process waits for a resource held by the next in a loop.'
        },
        {
          'questionText': 'Which is NOT a strategy for managing deadlocks?',
          'options': ['Deadlock prevention', 'Deadlock avoidance', 'Deadlock detection and recovery', 'Process duplication'],
          'correctAnswer': 'Process duplication',
          'explanation': 'Process duplication isn’t a deadlock strategy; the others address deadlocks directly.'
        },
        {
          'questionText': 'Which algorithm helps avoid deadlocks?',
          'options': ['Banker’s Algorithm', 'FIFO Algorithm', 'Round Robin Scheduling', 'Paging Algorithm'],
          'correctAnswer': 'Banker’s Algorithm',
          'explanation': 'Banker’s Algorithm ensures resource allocation avoids unsafe states leading to deadlocks.'
        },
        {
          'questionText': 'What does deadlock prevention involve?',
          'options': ['Removing a deadlock condition', 'Allowing deadlocks', 'Detecting deadlocks', 'Ignoring deadlocks'],
          'correctAnswer': 'Removing a deadlock condition',
          'explanation': 'Prevention eliminates one of the four conditions needed for deadlocks to occur.'
        },
        {
          'questionText': 'How does deadlock prevention differ from avoidance?',
          'options': ['Prevention eliminates, avoidance avoids', 'Prevention allows, avoidance ignores', 'Prevention detects, avoidance terminates', 'Prevention uses paging, avoidance swaps'],
          'correctAnswer': 'Prevention eliminates, avoidance avoids',
          'explanation': 'Prevention removes conditions; avoidance dynamically ensures deadlocks don’t form.'
        },
        {
          'questionText': 'What tool is used to detect deadlocks?',
          'options': ['Resource allocation graph', 'Paging table', 'FIFO queue', 'Interrupt vector'],
          'correctAnswer': 'Resource allocation graph',
          'explanation': 'A resource allocation graph shows resource dependencies to identify deadlock cycles.'
        },
        {
          'questionText': 'What does deadlock recovery typically entail?',
          'options': ['Terminating processes or preempting resources', 'Raising process priority', 'Allocating CPU cycles', 'Adding memory'],
          'correctAnswer': 'Terminating processes or preempting resources',
          'explanation': 'Recovery breaks deadlocks by terminating processes or taking resources back.'
        },
        {
          'questionText': 'Which is NOT a method to resolve a deadlock?',
          'options': ['Killing a process', 'Resource preemption', 'Running processes indefinitely', 'Adding resources'],
          'correctAnswer': 'Running processes indefinitely',
          'explanation': 'Running indefinitely worsens deadlocks; the others help resolve them.'
        },
        {
          'questionText': 'What is starvation in the context of process scheduling?',
          'options': ['Indefinite waiting due to resources', 'First-executed process', 'Memory overuse', 'Deadlock creator'],
          'correctAnswer': 'Indefinite waiting due to resources',
          'explanation': 'Starvation occurs when a process is perpetually denied resources by scheduling.'
        },
        {
          'questionText': 'What action does a system take upon detecting a deadlock?',
          'options': ['Terminates some processes', 'Waits for completion', 'Boosts CPU speed', 'Ignores the deadlock'],
          'correctAnswer': 'Terminates some processes',
          'explanation': 'The system resolves deadlocks by terminating or rolling back processes.'
        },
        {
          'questionText': 'What does a wait-for graph indicate?',
          'options': ['Deadlock detection', 'CPU scheduling order', 'Memory allocation', 'File system layout'],
          'correctAnswer': 'Deadlock detection',
          'explanation': 'A wait-for graph shows process dependencies to detect deadlock cycles.'
        },
        {
          'questionText': 'Which scenario exemplifies a deadlock?',
          'options': ['Two trains waiting on the same track', 'Memory paging process', 'Multi-threaded CPU', 'Disk writing data'],
          'correctAnswer': 'Two trains waiting on the same track',
          'explanation': 'This mirrors processes waiting circularly for resources, a classic deadlock example.'
        },
        {
          'questionText': 'Which deadlock reduction method uses timestamps?',
          'options': ['Wait-Die Scheme', 'Round Robin', 'FIFO Algorithm', 'Multilevel Queue Scheduling'],
          'correctAnswer': 'Wait-Die Scheme',
          'explanation': 'Wait-Die uses timestamps to decide whether a process waits or dies, reducing deadlocks.'
        }
      ],
      'OS_Module 4_Mock Test 1': [
        {
          'questionText': 'What is the primary goal of memory management in an OS?',
          'options': ['Execute CPU instructions', 'Efficiently allocate and manage memory', 'Schedule processes', 'Store files permanently'],
          'correctAnswer': 'Efficiently allocate and manage memory',
          'explanation': 'Memory management ensures efficient use of RAM for processes and data.'
        },
        {
          'questionText': 'Which technique is used for memory management?',
          'options': ['Paging', 'Scheduling', 'Pipelining', 'Thrashing'],
          'correctAnswer': 'Paging',
          'explanation': 'Paging divides memory into fixed-size blocks to manage allocation.'
        },
        {
          'questionText': 'What is unused memory within an allocated block called?',
          'options': ['Internal fragmentation', 'External fragmentation', 'Page fault', 'Deadlock'],
          'correctAnswer': 'Internal fragmentation',
          'explanation': 'Internal fragmentation occurs when allocated memory isn’t fully utilized.'
        },
        {
          'questionText': 'What does external fragmentation refer to?',
          'options': ['Wasted memory inside blocks', 'Unusable memory gaps', 'Virtual memory exhaustion', 'Swapping to disk'],
          'correctAnswer': 'Unusable memory gaps',
          'explanation': 'External fragmentation leaves small, unusable gaps between allocated blocks.'
        },
        {
          'questionText': 'Which memory allocation method causes external fragmentation?',
          'options': ['Paging', 'Segmentation', 'Contiguous memory allocation', 'Demand paging'],
          'correctAnswer': 'Contiguous memory allocation',
          'explanation': 'Contiguous allocation creates gaps as processes are loaded and removed.'
        },
        {
          'questionText': 'Which algorithm picks the smallest partition for a process?',
          'options': ['First Fit', 'Best Fit', 'Worst Fit', 'Next Fit'],
          'correctAnswer': 'Best Fit',
          'explanation': 'Best Fit selects the smallest available partition that fits the process.'
        },
        {
          'questionText': 'What does swapping mean in memory management?',
          'options': ['Moving processes between RAM and disk', 'Changing scheduling policies', 'Exchanging process memory', 'Expanding cache'],
          'correctAnswer': 'Moving processes between RAM and disk',
          'explanation': 'Swapping temporarily moves processes to disk to free up RAM.'
        },
        {
          'questionText': 'What defines paging in memory management?',
          'options': ['Deadlock prevention', 'Fixed-size memory blocks', 'CPU scheduling', 'File system organization'],
          'correctAnswer': 'Fixed-size memory blocks',
          'explanation': 'Paging splits memory into fixed-size pages for efficient allocation.'
        },
        {
          'questionText': 'What is the role of a page table?',
          'options': ['Stores process priorities', 'Maps logical to physical addresses', 'Manages CPU scheduling', 'Tracks running processes'],
          'correctAnswer': 'Maps logical to physical addresses',
          'explanation': 'The page table translates process logical addresses to physical RAM locations.'
        },
        {
          'questionText': 'What is the page size in paging systems?',
          'options': ['Fixed', 'Variable', 'Process-dependent', 'Unlimited'],
          'correctAnswer': 'Fixed',
          'explanation': 'Pages are fixed-size units, simplifying memory management.'
        },
        {
          'questionText': 'How does segmentation organize memory?',
          'options': ['Fixed-size blocks', 'Variable-size sections', 'Logical partitions', 'Stack memory'],
          'correctAnswer': 'Variable-size sections',
          'explanation': 'Segmentation divides memory into variable-size segments based on program structure.'
        },
        {
          'questionText': 'What issue does paging eliminate?',
          'options': ['External fragmentation', 'CPU scheduling delays', 'I/O bottlenecks', 'Process starvation'],
          'correctAnswer': 'External fragmentation',
          'explanation': 'Paging’s fixed-size blocks prevent gaps between allocations.'
        },
        {
          'questionText': 'What is a frame in the context of paging?',
          'options': ['Secondary storage section', 'Fixed-size physical memory block', 'CPU execution unit', 'Process cycle'],
          'correctAnswer': 'Fixed-size physical memory block',
          'explanation': 'Frames are fixed-size slots in physical memory that hold pages.'
        },
        {
          'questionText': 'Which address type does the CPU generate?',
          'options': ['Physical address', 'Logical address', 'Virtual address', 'Page address'],
          'correctAnswer': 'Logical address',
          'explanation': 'The CPU generates logical addresses, translated to physical ones by the OS.'
        },
        {
          'questionText': 'How does demand paging function?',
          'options': ['Loads all pages at start', 'Loads pages on demand', 'Uses fixed partitions', 'Applies CPU scheduling'],
          'correctAnswer': 'Loads pages on demand',
          'explanation': 'Demand paging loads pages into memory only when referenced.'
        }
      ],
      'OS_Module 4_Mock Test 2': [
        {
          'questionText': 'What is virtual memory in an OS?',
          'options': ['Disk space extending RAM', 'A hardware storage device', 'A type of ROM', 'A security feature'],
          'correctAnswer': 'Disk space extending RAM',
          'explanation': 'Virtual memory uses disk space to simulate additional RAM for processes.'
        },
        {
          'questionText': 'Which is a page replacement algorithm?',
          'options': ['Least Recently Used (LRU)', 'Round Robin', 'Shortest Job Next', 'Priority Scheduling'],
          'correctAnswer': 'Least Recently Used (LRU)',
          'explanation': 'LRU replaces the least recently used page when memory is full.'
        },
        {
          'questionText': 'What occurs if a page isn’t in memory when needed?',
          'options': ['A page fault', 'Process termination', 'OS reboot', 'Priority increase'],
          'correctAnswer': 'A page fault',
          'explanation': 'A page fault triggers the OS to load the missing page from disk.'
        },
        {
          'questionText': 'Which algorithm replaces the oldest page first?',
          'options': ['FIFO', 'LRU', 'Optimal', 'Second-Chance'],
          'correctAnswer': 'FIFO',
          'explanation': 'FIFO (First-In-First-Out) removes the page that’s been in memory longest.'
        },
        {
          'questionText': 'Which page replacement algorithm is theoretically optimal?',
          'options': ['FIFO', 'LRU', 'Optimal', 'Clock'],
          'correctAnswer': 'Optimal',
          'explanation': 'Optimal replaces the page not needed for the longest time, but requires future knowledge.'
        },
        {
          'questionText': 'What causes thrashing in a system?',
          'options': ['Excessive page swapping', 'Fixed-size partitions', 'High CPU usage', 'Low I/O activity'],
          'correctAnswer': 'Excessive page swapping',
          'explanation': 'Thrashing happens when excessive page faults overload the system with swaps.'
        },
        {
          'questionText': 'How can thrashing be minimized?',
          'options': ['Increase page frames', 'Reduce process count', 'Optimize CPU scheduling', 'Both a and b'],
          'correctAnswer': 'Both a and b',
          'explanation': 'More frames or fewer processes reduce page faults and swapping.'
        },
        {
          'questionText': 'What does memory compaction achieve?',
          'options': ['Reduces fragmentation', 'Dynamic allocation', 'Page swapping', 'Block allocation'],
          'correctAnswer': 'Reduces fragmentation',
          'explanation': 'Compaction reorganizes memory to consolidate free space, reducing external fragmentation.'
        },
        {
          'questionText': 'What is the purpose of the Translation Lookaside Buffer (TLB)?',
          'options': ['Speeds up address translation', 'Stores user files', 'Sets process priority', 'Manages scheduling'],
          'correctAnswer': 'Speeds up address translation',
          'explanation': 'The TLB caches address mappings to accelerate logical-to-physical translation.'
        },
        {
          'questionText': 'Which hardware supports memory protection?',
          'options': ['MMU', 'CPU', 'Hard Disk', 'ROM'],
          'correctAnswer': 'MMU',
          'explanation': 'The Memory Management Unit (MMU) enforces memory access boundaries.'
        },
        {
          'questionText': 'What does memory protection ensure?',
          'options': ['Prevents unauthorized access', 'Allows memory sharing', 'Increases fragmentation', 'Ensures sequential execution'],
          'correctAnswer': 'Prevents unauthorized access',
          'explanation': 'Memory protection stops processes from accessing others’ memory spaces.'
        },
        {
          'questionText': 'What is a key drawback of segmentation?',
          'options': ['External fragmentation', 'Internal fragmentation', 'Fixed-size blocks', 'No logical division'],
          'correctAnswer': 'External fragmentation',
          'explanation': 'Segmentation’s variable sizes lead to gaps between segments.'
        },
        {
          'questionText': 'What is the primary benefit of virtual memory?',
          'options': ['Runs programs beyond physical RAM', 'Boosts CPU speed', 'Eliminates RAM need', 'Speeds disk ops'],
          'correctAnswer': 'Runs programs beyond physical RAM',
          'explanation': 'Virtual memory lets large programs run by using disk as extra memory.'
        },
        {
          'questionText': 'Which memory type is the fastest?',
          'options': ['Cache memory', 'Virtual memory', 'Secondary storage', 'Main memory'],
          'correctAnswer': 'Cache memory',
          'explanation': 'Cache memory is the fastest, located closest to the CPU.'
        },
        {
          'questionText': 'Which method minimizes internal fragmentation?',
          'options': ['Paging', 'Segmentation', 'Contiguous allocation', 'Swapping'],
          'correctAnswer': 'Paging',
          'explanation': 'Paging’s fixed-size blocks reduce wasted space within allocations.'
        }
      ],
      'OS_Module 5_Mock Test 1': [
        {
          'questionText': 'What defines a file system in an OS?',
          'options': ['Organizes files on storage', 'Schedules processes', 'Allocates memory', 'Manages databases'],
          'correctAnswer': 'Organizes files on storage',
          'explanation': 'A file system structures and manages file storage on devices like disks.'
        },
        {
          'questionText': 'Which is NOT a typical file attribute?',
          'options': ['Name', 'Size', 'Memory Address', 'Permissions'],
          'correctAnswer': 'Memory Address',
          'explanation': 'Memory Address isn’t a file attribute; it’s a memory management concept.'
        },
        {
          'questionText': 'Which is NOT considered a file type?',
          'options': ['Text file', 'Executable file', 'Process file', 'Directory file'],
          'correctAnswer': 'Process file',
          'explanation': 'Process file isn’t a standard file type; others represent actual files.'
        },
        {
          'questionText': 'Which file structure uses a linear data sequence?',
          'options': ['Sequential file', 'Indexed file', 'Direct file', 'Hashed file'],
          'correctAnswer': 'Sequential file',
          'explanation': 'Sequential files store data in a continuous, ordered sequence.'
        },
        {
          'questionText': 'Which allocation method uses contiguous memory for files?',
          'options': ['Contiguous allocation', 'Linked allocation', 'Indexed allocation', 'Hashed allocation'],
          'correctAnswer': 'Contiguous allocation',
          'explanation': 'Contiguous allocation places file data in consecutive memory blocks.'
        },
        {
          'questionText': 'What is a directory in the context of a file system?',
          'options': ['A collection of files', 'A hardware component', 'A virtual memory slot', 'A storage type'],
          'correctAnswer': 'A collection of files',
          'explanation': 'A directory groups and organizes files within the file system.'
        },
        {
          'questionText': 'Which operations are valid for files?',
          'options': ['Open', 'Close', 'Read', 'All of the above'],
          'correctAnswer': 'All of the above',
          'explanation': 'Open, Close, and Read are fundamental file operations in an OS.'
        },
        {
          'questionText': 'Which allocation method uses pointers to link file blocks?',
          'options': ['Contiguous allocation', 'Linked allocation', 'Indexed allocation', 'Hashed allocation'],
          'correctAnswer': 'Linked allocation',
          'explanation': 'Linked allocation chains blocks using pointers for non-contiguous storage.'
        },
        {
          'questionText': 'What is a key benefit of indexed allocation?',
          'options': ['No external fragmentation', 'Fast direct access', 'Efficient space use', 'All of the above'],
          'correctAnswer': 'All of the above',
          'explanation': 'Indexed allocation offers all these advantages by using an index block.'
        },
        {
          'questionText': 'Which access method reads files from the start sequentially?',
          'options': ['Direct access', 'Random access', 'Sequential access', 'Indexed access'],
          'correctAnswer': 'Sequential access',
          'explanation': 'Sequential access processes records in order from the beginning.'
        },
        {
          'questionText': 'Which method allows record retrieval without prior reads?',
          'options': ['Sequential access', 'Direct access', 'Indexed access', 'Contiguous access'],
          'correctAnswer': 'Direct access',
          'explanation': 'Direct access jumps to a specific record without reading others.'
        },
        {
          'questionText': 'Which structure holds file metadata?',
          'options': ['File Descriptor', 'Page Table', 'Directory Table', 'I-Node'],
          'correctAnswer': 'I-Node',
          'explanation': 'An I-Node stores file metadata like size and location in UNIX-like systems.'
        },
        {
          'questionText': 'Which task is NOT a file system function?',
          'options': ['File creation', 'File storage', 'Process execution', 'File protection'],
          'correctAnswer': 'Process execution',
          'explanation': 'Process execution is handled by the OS kernel, not the file system.'
        },
        {
          'questionText': 'Which is NOT a secondary storage device?',
          'options': ['Hard Disk', 'RAM', 'SSD', 'CD-ROM'],
          'correctAnswer': 'RAM',
          'explanation': 'RAM is primary memory; the others are secondary storage.'
        },
        {
          'questionText': 'Which disk scheduling picks the closest request to the head?',
          'options': ['FCFS', 'SSTF', 'SCAN', 'C-SCAN'],
          'correctAnswer': 'SSTF',
          'explanation': 'Shortest Seek Time First (SSTF) minimizes head movement by proximity.'
        }
      ],
      'OS_Module 5_Mock Test 2': [
        {
          'questionText': 'Which disk scheduling moves the head across the disk and back?',
          'options': ['FCFS', 'SSTF', 'SCAN', 'LOOK'],
          'correctAnswer': 'SCAN',
          'explanation': 'SCAN sweeps the head from one end to the other, servicing requests.'
        },
        {
          'questionText': 'Which is NOT a disk scheduling algorithm?',
          'options': ['FIFO', 'LOOK', 'C-SCAN', 'LRU'],
          'correctAnswer': 'LRU',
          'explanation': 'LRU is a page replacement algorithm, not for disk scheduling.'
        },
        {
          'questionText': 'Which disk scheduling avoids starvation?',
          'options': ['SSTF', 'SCAN', 'FCFS', 'Round Robin'],
          'correctAnswer': 'SCAN',
          'explanation': 'SCAN ensures all requests are eventually serviced by sweeping the disk.'
        },
        {
          'questionText': 'What does disk partitioning accomplish?',
          'options': ['Divides disk into logical sections', 'Boosts CPU speed', 'Fixes disk errors', 'Prevents corruption'],
          'correctAnswer': 'Divides disk into logical sections',
          'explanation': 'Partitioning splits a disk into manageable logical units.'
        },
        {
          'questionText': 'What does RAID stand for in storage management?',
          'options': ['Disk scheduling technique', 'Reliability and performance enhancement', 'Cache replacement policy', 'File system type'],
          'correctAnswer': 'Reliability and performance enhancement',
          'explanation': 'RAID improves storage reliability and speed using redundancy and striping.'
        },
        {
          'questionText': 'Which is NOT a file protection technique?',
          'options': ['Access control lists', 'Encryption', 'Paging', 'User authentication'],
          'correctAnswer': 'Paging',
          'explanation': 'Paging is a memory management method, not file protection.'
        },
        {
          'questionText': 'Which permission allows file modification?',
          'options': ['Read', 'Write', 'Execute', 'Delete'],
          'correctAnswer': 'Write',
          'explanation': 'Write permission enables a user to edit or modify a file’s contents.'
        },
        {
          'questionText': 'What is the role of an access control list (ACL)?',
          'options': ['Manages fragmentation', 'Sets user/group permissions', 'Schedules disk I/O', 'Logs process history'],
          'correctAnswer': 'Sets user/group permissions',
          'explanation': 'An ACL specifies access rights for users and groups to files.'
        },
        {
          'questionText': 'What is the goal of file encryption?',
          'options': ['Improves compression', 'Prevents unauthorized access', 'Speeds file transfer', 'Increases disk space'],
          'correctAnswer': 'Prevents unauthorized access',
          'explanation': 'Encryption secures files by making them unreadable without a key.'
        },
        {
          'questionText': 'Which UNIX command modifies file permissions?',
          'options': ['chmod', 'ls', 'rm', 'cp'],
          'correctAnswer': 'chmod',
          'explanation': 'chmod (change mode) adjusts file access permissions in UNIX.'
        },
        {
          'questionText': 'Which is NOT a file system security threat?',
          'options': ['Malware', 'Unauthorized access', 'Deadlock', 'Data corruption'],
          'correctAnswer': 'Deadlock',
          'explanation': 'Deadlock is a process issue, not a direct file system security threat.'
        },
        {
          'questionText': 'Which file systems use journaling?',
          'options': ['FAT32', 'NTFS', 'EXT3', 'Both b and c'],
          'correctAnswer': 'Both b and c',
          'explanation': 'NTFS and EXT3 use journaling to log changes for recovery; FAT32 does not.'
        },
        {
          'questionText': 'Which file system is standard in Windows?',
          'options': ['EXT4', 'NTFS', 'XFS', 'HFS+'],
          'correctAnswer': 'NTFS',
          'explanation': 'NTFS is the default file system for modern Windows OS versions.'
        },
        {
          'questionText': 'Which file system is widely used in Linux?',
          'options': ['FAT32', 'EXT4', 'NTFS', 'HFS+'],
          'correctAnswer': 'EXT4',
          'explanation': 'EXT4 is a common, efficient file system in Linux distributions.'
        },
        {
          'questionText': 'What does defragmentation achieve?',
          'options': ['Rearranges files for faster access', 'Encrypts files', 'Expands RAM', 'Alters permissions'],
          'correctAnswer': 'Rearranges files for faster access',
          'explanation': 'Defragmentation consolidates file fragments to improve read/write speed.'
        }
      ],
      //DBMS
      'DBMS_Module 1_Mock Test 1': [
        // 1. Database Basics
        {
          'questionText': 'A database is a collection of:',
          'options': ['Tables', 'Related data', 'Records', 'Files'],
          'correctAnswer': 'Related data',
          'explanation': 'A database is an organized collection of related data, typically stored and accessed electronically.'
        },
        {
          'questionText': 'A DBMS is used to:',
          'options': ['Manage large amounts of data', 'Increase data redundancy', 'Delete records automatically', 'Restrict data access'],
          'correctAnswer': 'Manage large amounts of data',
          'explanation': 'A Database Management System (DBMS) is software designed to efficiently manage large amounts of data.'
        },
        {
          'questionText': 'The logical structure of a database is called:',
          'options': ['Schema', 'Table', 'Field', 'Relation'],
          'correctAnswer': 'Schema',
          'explanation': 'The schema defines the logical structure of a database, including tables, fields, and relationships.'
        },
        {
          'questionText': 'A record in a database represents:',
          'options': ['A column', 'A row', 'A table', 'A relation'],
          'correctAnswer': 'A row',
          'explanation': 'A record in a database corresponds to a single row in a table, representing a single entry.'
        },
        {
          'questionText': 'A tuple in a relational model refers to:',
          'options': ['A database', 'A column', 'A row', 'A key'],
          'correctAnswer': 'A row',
          'explanation': 'In the relational model, a tuple is synonymous with a row in a table.'
        },

        // 2. ER Model and Database Models
        {
          'questionText': 'A one-to-many relationship in an ER diagram is represented by:',
          'options': ['One entity linking to multiple entities', 'Many entities linking to one entity', 'A single table', 'A one-to-one mapping'],
          'correctAnswer': 'One entity linking to multiple entities',
          'explanation': 'In an ER diagram, a one-to-many relationship shows one entity related to multiple instances of another entity.'
        },
        {
          'questionText': 'A weak entity depends on:',
          'options': ['Another strong entity', 'A primary key', 'A foreign key', 'Its own attributes'],
          'correctAnswer': 'Another strong entity',
          'explanation': 'A weak entity relies on a strong entity for its existence and identification.'
        },
        {
          'questionText': 'A composite attribute in an ER model is:',
          'options': ['An attribute that has multiple components', 'A foreign key', 'A derived attribute', 'A primary key'],
          'correctAnswer': 'An attribute that has multiple components',
          'explanation': 'A composite attribute can be divided into smaller sub-attributes (e.g., full name into first and last name).'
        },
        {
          'questionText': 'A multivalued attribute in an ER diagram is represented by:',
          'options': ['A rectangle', 'A double ellipse', 'A diamond', 'A triangle'],
          'correctAnswer': 'A double ellipse',
          'explanation': 'In ER diagrams, a multivalued attribute is denoted by a double ellipse (e.g., phone numbers).'
        },
        {
          'questionText': 'The degree of a relation refers to the number of:',
          'options': ['Rows', 'Columns', 'Foreign keys', 'Relationships'],
          'correctAnswer': 'Columns',
          'explanation': 'The degree of a relation is the number of attributes (columns) in a table.'
        },

        // 3. Keys and Constraints
        {
          'questionText': 'A super key is:',
          'options': ['A minimal key that uniquely identifies tuples', 'Any key that uniquely identifies tuples', 'Always the primary key', 'Used for indexing'],
          'correctAnswer': 'Any key that uniquely identifies tuples',
          'explanation': 'A super key is any set of attributes that can uniquely identify a tuple, not necessarily minimal.'
        },
        {
          'questionText': 'A foreign key ensures:',
          'options': ['Entity integrity', 'Referential integrity', 'Data redundancy', 'Performance improvement'],
          'correctAnswer': 'Referential integrity',
          'explanation': 'A foreign key maintains referential integrity by linking data between tables consistently.'
        },
        {
          'questionText': 'A candidate key is:',
          'options': ['The same as the primary key', 'A potential primary key', 'A foreign key', 'An index'],
          'correctAnswer': 'A potential primary key',
          'explanation': 'A candidate key is a minimal set of attributes that could serve as a primary key.'
        },
        {
          'questionText': 'A primary key must be:',
          'options': ['Unique and NOT NULL', 'NULL', 'Duplicated', 'A foreign key'],
          'correctAnswer': 'Unique and NOT NULL',
          'explanation': 'A primary key must uniquely identify each tuple and cannot contain NULL values.'
        },
        {
          'questionText': 'A composite key consists of:',
          'options': ['A single attribute', 'Multiple attributes', 'A foreign key', 'A unique index'],
          'correctAnswer': 'Multiple attributes',
          'explanation': 'A composite key is a primary key made up of two or more attributes.'
        },

        // 4. SQL & Database Languages

      ],
      'DBMS_Module 1_Mock Test 2': [
        {
          'questionText': 'SQL stands for:',
          'options': ['Structured Query Language', 'Sequential Query Language', 'Systematic Query Language', 'Standard Query Language'],
          'correctAnswer': 'Structured Query Language',
          'explanation': 'SQL stands for Structured Query Language, used for managing relational databases.'
        },
        {
          'questionText': 'The command to retrieve data from a table is:',
          'options': ['INSERT', 'SELECT', 'DELETE', 'UPDATE'],
          'correctAnswer': 'SELECT',
          'explanation': 'The SELECT command is used to query and retrieve data from a database table.'
        },
        {
          'questionText': 'The HAVING clause is used with:',
          'options': ['ORDER BY', 'GROUP BY', 'SELECT', 'DELETE'],
          'correctAnswer': 'GROUP BY',
          'explanation': 'The HAVING clause filters grouped results, typically used with GROUP BY.'
        },
        {
          'questionText': 'The SQL command to remove all rows from a table is:',
          'options': ['DELETE', 'DROP', 'TRUNCATE', 'REMOVE'],
          'correctAnswer': 'TRUNCATE',
          'explanation': 'TRUNCATE removes all rows from a table efficiently, without logging individual deletions.'
        },
        {
          'questionText': 'The SQL command to change data in a table is:',
          'options': ['ALTER', 'UPDATE', 'MODIFY', 'CHANGE'],
          'correctAnswer': 'UPDATE',
          'explanation': 'The UPDATE command modifies existing data in a table.'
        },

        // 5. Transactions & ACID Properties
        {
          'questionText': 'The ACID properties in a DBMS ensure:',
          'options': ['Atomicity, Consistency, Isolation, Durability', 'Accessible, Computed, Indexed, Defined transactions', 'Accurate, Computed, Indexed, Defined transactions', 'All data is public'],
          'correctAnswer': 'Atomicity, Consistency, Isolation, Durability',
          'explanation': 'ACID properties ensure reliable database transactions.'
        },
        {
          'questionText': 'A commit operation in SQL:',
          'options': ['Saves changes permanently', 'Reverts changes', 'Deletes records', 'Ends a transaction without saving'],
          'correctAnswer': 'Saves changes permanently',
          'explanation': 'COMMIT makes all transaction changes permanent in the database.'
        },
        {
          'questionText': 'A rollback operation:',
          'options': ['Reverts changes in a transaction', 'Deletes a table', 'Commits a transaction', 'Creates a backup'],
          'correctAnswer': 'Reverts changes in a transaction',
          'explanation': 'ROLLBACK undoes all changes made during a transaction.'
        },
        {
          'questionText': 'The isolation property ensures:',
          'options': ['Transactions do not interfere with each other', 'Data is encrypted', 'Transactions execute faster', 'Deadlocks do not occur'],
          'correctAnswer': 'Transactions do not interfere with each other',
          'explanation': 'Isolation ensures transactions are executed independently of one another.'
        },
        {
          'questionText': 'A deadlock occurs when:',
          'options': ['Two transactions wait indefinitely', 'Data is lost', 'Transactions execute sequentially', 'Memory is full'],
          'correctAnswer': 'Two transactions wait indefinitely',
          'explanation': 'A deadlock happens when transactions block each other, causing an indefinite wait.'
        },

        // 6. Normalization & Indexing
        {
          'questionText': 'The purpose of normalization is to:',
          'options': ['Reduce redundancy', 'Improve performance', 'Increase inconsistency', 'Reduce constraints'],
          'correctAnswer': 'Reduce redundancy',
          'explanation': 'Normalization organizes data to minimize redundancy and dependency issues.'
        },
        {
          'questionText': '1NF removes:',
          'options': ['Multivalued attributes', 'Transitive dependencies', 'Partial dependencies', 'Redundant keys'],
          'correctAnswer': 'Multivalued attributes',
          'explanation': 'First Normal Form (1NF) eliminates multivalued attributes by ensuring atomicity.'
        },
        {
          'questionText': '2NF eliminates:',
          'options': ['Partial dependencies', 'Transitive dependencies', 'Multivalued attributes', 'Super keys'],
          'correctAnswer': 'Partial dependencies',
          'explanation': 'Second Normal Form (2NF) removes partial dependencies on composite keys.'
        },
        {
          'questionText': '3NF removes:',
          'options': ['Transitive dependencies', 'Partial dependencies', 'Foreign key constraints', 'Primary keys'],
          'correctAnswer': 'Transitive dependencies',
          'explanation': 'Third Normal Form (3NF) eliminates transitive dependencies between non-key attributes.'
        },
        {
          'questionText': 'BCNF is stricter than:',
          'options': ['1NF', '2NF', '3NF', '4NF'],
          'correctAnswer': '3NF',
          'explanation': 'Boyce-Codd Normal Form (BCNF) is a stricter version of 3NF, addressing certain anomalies.'
        }
      ],
      'DBMS_Module 2_Mock Test 1': [
        // 1. Relational Model Basics (5 questions)
        {
          'questionText': 'Which of the following is a characteristic of the relational model?',
          'options': ['Data is stored in hierarchical format', 'Data is stored in tables with rows and columns', 'Data is stored in tree structures', 'Data is stored in object-oriented format'],
          'correctAnswer': 'Data is stored in tables with rows and columns',
          'explanation': 'The relational model organizes data into tables with rows and columns.'
        },
        {
          'questionText': 'A relation in a relational database is represented as:',
          'options': ['A tree', 'A table', 'A graph', 'A record'],
          'correctAnswer': 'A table',
          'explanation': 'A relation is represented as a table in the relational model.'
        },
        {
          'questionText': 'A tuple in a relational table represents:',
          'options': ['A row', 'A column', 'A key', 'A constraint'],
          'correctAnswer': 'A row',
          'explanation': 'A tuple corresponds to a single row in a relational table.'
        },
        {
          'questionText': 'A superkey is:',
          'options': ['A single attribute that uniquely identifies a tuple', 'A set of attributes that uniquely identifies a tuple', 'A candidate key that is used as a primary key', 'A foreign key'],
          'correctAnswer': 'A set of attributes that uniquely identifies a tuple',
          'explanation': 'A superkey is any set of attributes that uniquely identifies a tuple.'
        },
        {
          'questionText': 'The relational model was proposed by:',
          'options': ['Edgar F. Codd', 'Charles Bachman', 'Peter Chen', 'James Watson'],
          'correctAnswer': 'Edgar F. Codd',
          'explanation': 'Edgar F. Codd proposed the relational model in 1970.'
        },

        // 2. Relational Algebra (5 questions)
        {
          'questionText': 'Which of the following is a fundamental operation in relational algebra?',
          'options': ['Selection', 'Aggregation', 'Normalization', 'Indexing'],
          'correctAnswer': 'Selection',
          'explanation': 'Selection retrieves rows from a relation based on a condition.'
        },
        {
          'questionText': 'The projection operation in relational algebra is used to:',
          'options': ['Retrieve specific columns from a relation', 'Retrieve specific rows from a relation', 'Perform joins', 'Remove duplicate values'],
          'correctAnswer': 'Retrieve specific columns from a relation',
          'explanation': 'Projection selects specific columns, reducing the attributes of a relation.'
        },
        {
          'questionText': 'The Cartesian product operation in relational algebra is also called:',
          'options': ['Cross join', 'Equi-join', 'Theta join', 'Semi-join'],
          'correctAnswer': 'Cross join',
          'explanation': 'Cartesian product combines all rows of two relations, known as a cross join.'
        },
        {
          'questionText': 'The difference operation in relational algebra returns:',
          'options': ['Common tuples from two relations', 'Tuples present in one relation but not in another', 'All tuples from both relations', 'A Cartesian product of two relations'],
          'correctAnswer': 'Tuples present in one relation but not in another',
          'explanation': 'Difference returns tuples in one relation but not in the other.'
        },
        {
          'questionText': 'Which operation is used to rename attributes in relational algebra?',
          'options': ['Selection', 'Projection', 'Rename', 'Join'],
          'correctAnswer': 'Rename',
          'explanation': 'The rename operation changes the name of a relation or its attributes.'
        },

        // 3. SQL Concepts (5 questions)
        {
          'questionText': 'Which SQL command is used to retrieve data from a database?',
          'options': ['SELECT', 'INSERT', 'UPDATE', 'DELETE'],
          'correctAnswer': 'SELECT',
          'explanation': 'SELECT retrieves data from one or more tables.'
        },
        {
          'questionText': 'The WHERE clause in SQL is used to:',
          'options': ['Filter records', 'Sort records', 'Group records', 'Delete records'],
          'correctAnswer': 'Filter records',
          'explanation': 'WHERE filters rows based on specified conditions.'
        },
        {
          'questionText': 'Which SQL function is used to find the total number of rows in a table?',
          'options': ['COUNT()', 'SUM()', 'MAX()', 'AVG()'],
          'correctAnswer': 'COUNT()',
          'explanation': 'COUNT() returns the total number of rows in a result set.'
        },
        {
          'questionText': 'The primary key of a table must be:',
          'options': ['Unique and NOT NULL', 'Only unique', 'Only NOT NULL', 'A foreign key'],
          'correctAnswer': 'Unique and NOT NULL',
          'explanation': 'A primary key must uniquely identify rows and cannot be NULL.'
        },
        {
          'questionText': 'Which SQL clause is used for sorting the result set?',
          'options': ['WHERE', 'ORDER BY', 'GROUP BY', 'HAVING'],
          'correctAnswer': 'ORDER BY',
          'explanation': 'ORDER BY sorts the result set in ascending or descending order.'
        },

        // 4. Joins in SQL (5 questions)

      ],
      'DBMS_Module 2_Mock Test 2': [
        {
          'questionText': 'Which of the following join types returns only matching rows from both tables?',
          'options': ['INNER JOIN', 'LEFT JOIN', 'RIGHT JOIN', 'FULL JOIN'],
          'correctAnswer': 'INNER JOIN',
          'explanation': 'INNER JOIN returns only rows with matching values in both tables.'
        },
        {
          'questionText': 'A LEFT JOIN returns:',
          'options': ['Only matching rows from both tables', 'All rows from the left table and matching rows from the right table', 'All rows from the right table and matching rows from the left table', 'Only unmatched rows from the left table'],
          'correctAnswer': 'All rows from the left table and matching rows from the right table',
          'explanation': 'LEFT JOIN includes all rows from the left table, with NULLs for non-matches.'
        },
        {
          'questionText': 'Which join type returns all records from both tables, filling NULLs where necessary?',
          'options': ['INNER JOIN', 'LEFT JOIN', 'FULL OUTER JOIN', 'CROSS JOIN'],
          'correctAnswer': 'FULL OUTER JOIN',
          'explanation': 'FULL OUTER JOIN includes all rows from both tables, with NULLs where unmatched.'
        },
        {
          'questionText': 'What is the result of a CROSS JOIN?',
          'options': ['A Cartesian product of the two tables', 'A natural join', 'A self-join', 'A filtered join'],
          'correctAnswer': 'A Cartesian product of the two tables',
          'explanation': 'CROSS JOIN combines every row from one table with every row from another.'
        },
        {
          'questionText': 'Which clause is used to specify join conditions?',
          'options': ['ON', 'WHERE', 'ORDER BY', 'GROUP BY'],
          'correctAnswer': 'ON',
          'explanation': 'ON specifies the condition for joining tables.'
        },

        // 5. Subqueries, Aggregate Functions, Constraints, and Transactions (10 questions)
        {
          'questionText': 'A subquery is:',
          'options': ['A query inside another query', 'A query that modifies data', 'A query that performs aggregation', 'A query that only returns a single row'],
          'correctAnswer': 'A query inside another query',
          'explanation': 'A subquery is a nested query within a main query.'
        },
        {
          'questionText': 'Which aggregate function is used to find the highest value in a column?',
          'options': ['COUNT()', 'MAX()', 'SUM()', 'MIN()'],
          'correctAnswer': 'MAX()',
          'explanation': 'MAX() returns the highest value in a column.'
        },
        {
          'questionText': 'Which aggregate function calculates the total sum of a column?',
          'options': ['COUNT()', 'MAX()', 'SUM()', 'AVG()'],
          'correctAnswer': 'SUM()',
          'explanation': 'SUM() computes the total sum of numeric values in a column.'
        },
        {
          'questionText': 'Which SQL clause is used with aggregate functions to group records?',
          'options': ['WHERE', 'ORDER BY', 'GROUP BY', 'HAVING'],
          'correctAnswer': 'GROUP BY',
          'explanation': 'GROUP BY groups rows for aggregate calculations.'
        },
        {
          'questionText': 'Which clause filters grouped records based on aggregate functions?',
          'options': ['WHERE', 'ORDER BY', 'GROUP BY', 'HAVING'],
          'correctAnswer': 'HAVING',
          'explanation': 'HAVING filters groups based on aggregate conditions.'
        },
        {
          'questionText': 'Which constraint ensures that no duplicate values are entered in a column?',
          'options': ['CHECK', 'UNIQUE', 'FOREIGN KEY', 'DEFAULT'],
          'correctAnswer': 'UNIQUE',
          'explanation': 'UNIQUE ensures all values in a column are distinct.'
        },
        {
          'questionText': 'Which constraint ensures referential integrity between two tables?',
          'options': ['UNIQUE', 'CHECK', 'FOREIGN KEY', 'NOT NULL'],
          'correctAnswer': 'FOREIGN KEY',
          'explanation': 'FOREIGN KEY links to a primary key in another table for referential integrity.'
        },
        {
          'questionText': 'Which SQL statement is used to permanently save a transaction?',
          'options': ['COMMIT', 'ROLLBACK', 'SAVEPOINT', 'DELETE'],
          'correctAnswer': 'COMMIT',
          'explanation': 'COMMIT saves transaction changes permanently.'
        },
        {
          'questionText': 'If a transaction fails and is reversed, which SQL command is used?',
          'options': ['COMMIT', 'ROLLBACK', 'SAVEPOINT', 'DELETE'],
          'correctAnswer': 'ROLLBACK',
          'explanation': 'ROLLBACK undoes changes if a transaction fails.'
        },
        {
          'questionText': 'A transaction that executes completely or does not execute at all follows the ACID property of:',
          'options': ['Atomicity', 'Consistency', 'Isolation', 'Durability'],
          'correctAnswer': 'Atomicity',
          'explanation': 'Atomicity ensures a transaction is an all-or-nothing operation.'
        }
      ],
      'DBMS_Module 3_Mock Test 1': [
        // 1. Normalization (10 questions)
        {
          'questionText': 'Which of the following is a trivial functional dependency?',
          'options': ['A → B', 'A → AB', 'AB → A', 'A → C'],
          'correctAnswer': 'AB → A',
          'explanation': 'A trivial functional dependency occurs when the right side is a subset of the left side, e.g., AB → A.'
        },
        {
          'questionText': 'A functional dependency A → B is called partial if:',
          'options': ['B is only partially dependent on A', 'B depends on part of a composite key', 'A is a primary key', 'A is a candidate key'],
          'correctAnswer': 'B depends on part of a composite key',
          'explanation': 'Partial dependency occurs when an attribute depends on only a portion of a composite key.'
        },
        {
          'questionText': 'Which normal form removes partial dependencies?',
          'options': ['1NF', '2NF', '3NF', 'BCNF'],
          'correctAnswer': '2NF',
          'explanation': 'Second Normal Form (2NF) eliminates partial dependencies on composite keys.'
        },
        {
          'questionText': 'Which dependency prevents a table from being in 3NF?',
          'options': ['Trivial dependency', 'Transitive dependency', 'Functional dependency', 'Partial dependency'],
          'correctAnswer': 'Transitive dependency',
          'explanation': 'Transitive dependencies must be removed for a table to be in 3NF.'
        },
        {
          'questionText': 'Which normal form ensures there is no multivalued attribute in a relation?',
          'options': ['1NF', '2NF', '3NF', 'BCNF'],
          'correctAnswer': '1NF',
          'explanation': 'First Normal Form (1NF) requires atomic values, removing multivalued attributes.'
        },
        {
          'questionText': 'What is the main goal of normalization?',
          'options': ['Reduce redundancy', 'Increase redundancy', 'Speed up query execution', 'Reduce foreign keys'],
          'correctAnswer': 'Reduce redundancy',
          'explanation': 'Normalization aims to minimize data redundancy and ensure data integrity.'
        },
        {
          'questionText': 'Which normal form ensures there are no transitive dependencies?',
          'options': ['1NF', '2NF', '3NF', 'BCNF'],
          'correctAnswer': '3NF',
          'explanation': 'Third Normal Form (3NF) removes transitive dependencies between non-key attributes.'
        },
        {
          'questionText': 'Which normal form ensures that only candidate keys determine non-prime attributes?',
          'options': ['2NF', '3NF', 'BCNF', '4NF'],
          'correctAnswer': 'BCNF',
          'explanation': 'Boyce-Codd Normal Form (BCNF) requires all determinants to be candidate keys.'
        },
        {
          'questionText': 'In which normal form does every non-trivial functional dependency have a superkey as the determinant?',
          'options': ['3NF', 'BCNF', '4NF', '5NF'],
          'correctAnswer': 'BCNF',
          'explanation': 'BCNF ensures every non-trivial dependency’s determinant is a superkey.'
        },
        {
          'questionText': 'What is the highest normal form if a relation has no multi-valued dependencies but has transitive dependencies?',
          'options': ['2NF', '3NF', 'BCNF', '4NF'],
          'correctAnswer': '2NF',
          'explanation': 'If transitive dependencies exist, the relation cannot reach 3NF; thus, it’s in 2NF.'
        },

        // 2. Decomposition & Dependency Preservation (5 questions)
        {
          'questionText': 'What is the main advantage of lossless decomposition?',
          'options': ['Data redundancy is increased', 'Original relation can be reconstructed', 'Dependencies are removed', 'Indexing becomes easier'],
          'correctAnswer': 'Original relation can be reconstructed',
          'explanation': 'Lossless decomposition ensures no data is lost, allowing the original relation to be rebuilt.'
        },
        {
          'questionText': 'A decomposition is considered dependency-preserving if:',
          'options': ['It eliminates redundancy', 'It does not change the functional dependencies', 'It removes anomalies', 'It reduces query time'],
          'correctAnswer': 'It does not change the functional dependencies',
          'explanation': 'Dependency preservation means all original functional dependencies are maintained.'
        },
        {
          'questionText': 'Which decomposition property ensures that all original functional dependencies are preserved?',
          'options': ['Lossless join', 'Dependency preservation', 'Normalization', 'Functional dependency'],
          'correctAnswer': 'Dependency preservation',
          'explanation': 'Dependency preservation ensures no functional dependencies are lost in decomposition.'
        },
        {
          'questionText': 'Which of the following is NOT a property of a good decomposition?',
          'options': ['Lossless join', 'Dependency preservation', 'Redundancy increase', 'Minimality'],
          'correctAnswer': 'Redundancy increase',
          'explanation': 'Good decomposition avoids increasing redundancy; it aims to reduce it.'
        },
        {
          'questionText': 'Lossless decomposition ensures that:',
          'options': ['Data is not lost after decomposition', 'Normalization is not needed', 'Functional dependencies are removed', 'Indexing is improved'],
          'correctAnswer': 'Data is not lost after decomposition',
          'explanation': 'Lossless decomposition guarantees that the original data can be recovered.'
        },

        // 3. Storage & File Organization (5 questions)


        // 4. Indexing Strategies (5 questions)

      ],
      'DBMS_Module 3_Mock Test 2': [
        {
          'questionText': 'Which file organization stores records in order of a key field?',
          'options': ['Heap', 'Sequential', 'Hashing', 'Indexed'],
          'correctAnswer': 'Sequential',
          'explanation': 'Sequential organization orders records based on a key field.'
        },
        {
          'questionText': 'Which file organization is best for searching operations?',
          'options': ['Sequential', 'Heap', 'Indexed', 'Hashing'],
          'correctAnswer': 'Indexed',
          'explanation': 'Indexed organization supports efficient searching via index structures.'
        },
        {
          'questionText': 'In which file organization method are records stored in any available location?',
          'options': ['Heap', 'Sequential', 'Indexed', 'Hashing'],
          'correctAnswer': 'Heap',
          'explanation': 'Heap organization places records in any available space without order.'
        },
        {
          'questionText': 'Which file organization is best for static tables?',
          'options': ['Heap', 'Indexed', 'Sequential', 'Hashing'],
          'correctAnswer': 'Sequential',
          'explanation': 'Sequential organization suits static tables due to its ordered structure.'
        },
        {
          'questionText': 'Which file structure uses hashing to locate records?',
          'options': ['Heap', 'Indexed', 'Direct access', 'Sequential'],
          'correctAnswer': 'Direct access',
          'explanation': 'Direct access uses hashing to locate records quickly.'
        },
        {
          'questionText': 'Which type of index stores every search key in the index?',
          'options': ['Sparse index', 'Dense index', 'Hash index', 'Clustered index'],
          'correctAnswer': 'Dense index',
          'explanation': 'A dense index contains an entry for every search key value.'
        },
        {
          'questionText': 'A sparse index stores:',
          'options': ['Every search key', 'Only selected keys', 'Only primary keys', 'Hash values of records'],
          'correctAnswer': 'Only selected keys',
          'explanation': 'A sparse index has entries for only some search key values, typically one per block.'
        },
        {
          'questionText': 'Which index type is automatically created when a primary key is defined?',
          'options': ['Clustered index', 'Non-clustered index', 'Hash index', 'Composite index'],
          'correctAnswer': 'Clustered index',
          'explanation': 'A clustered index is created automatically for a primary key to physically order data.'
        },
        {
          'questionText': 'B+ trees are used in:',
          'options': ['Hash indexing', 'Sequential file organization', 'Multi-level indexing', 'Random file access'],
          'correctAnswer': 'Multi-level indexing',
          'explanation': 'B+ trees provide efficient multi-level indexing for range queries.'
        },
        {
          'questionText': 'Which index method allows fast range searches?',
          'options': ['Hash index', 'B+ tree index', 'Bitmap index', 'Dense index'],
          'correctAnswer': 'B+ tree index',
          'explanation': 'B+ trees support fast range searches due to their ordered structure.'
        },

        // 5. Hashing Techniques (5 questions)
        {
          'questionText': 'Which hashing technique allows dynamic expansion of the hash table?',
          'options': ['Static hashing', 'Dynamic hashing', 'Open hashing', 'Chaining'],
          'correctAnswer': 'Dynamic hashing',
          'explanation': 'Dynamic hashing adjusts the table size as data grows.'
        },
        {
          'questionText': 'Which hashing method handles collisions by using a linked list?',
          'options': ['Linear probing', 'Open addressing', 'Chaining', 'Double hashing'],
          'correctAnswer': 'Chaining',
          'explanation': 'Chaining resolves collisions by storing colliding records in a linked list.'
        },
        {
          'questionText': 'In linear probing, when a collision occurs:',
          'options': ['The record is stored in the next available slot', 'A new hash function is applied', 'The record is lost', 'The table is reorganized'],
          'correctAnswer': 'The record is stored in the next available slot',
          'explanation': 'Linear probing places the record in the next free slot after a collision.'
        },
        {
          'questionText': 'Which hashing technique uses two hash functions to resolve collisions?',
          'options': ['Linear probing', 'Double hashing', 'Chaining', 'Open hashing'],
          'correctAnswer': 'Double hashing',
          'explanation': 'Double hashing uses a second hash function to find an alternative slot.'
        },
        {
          'questionText': 'What is the primary advantage of extendible hashing?',
          'options': ['Allows dynamic table growth', 'Requires less memory', 'Uses a fixed number of buckets', 'Does not need a hash function'],
          'correctAnswer': 'Allows dynamic table growth',
          'explanation': 'Extendible hashing supports table expansion without full reorganization.'
        }
      ],
      'DBMS_Module 4_Mock Test 1': [
        {
          'questionText': 'Which of the following is used to speed up database searches?',
          'options': ['Foreign Key', 'Indexing', 'Joins', 'Aggregation'],
          'correctAnswer': 'Indexing',
          'explanation': 'Indexing creates data structures to speed up search operations in a database.'
        },
        {
          'questionText': 'An index is created on:',
          'options': ['Rows of a table', 'Columns of a table', 'Whole database', 'Joins of tables'],
          'correctAnswer': 'Columns of a table',
          'explanation': 'Indexes are built on specific columns to improve retrieval efficiency.'
        },
        {
          'questionText': 'Which type of index allows fast searching in sorted order?',
          'options': ['Clustered index', 'Hash index', 'Bitmap index', 'None of the above'],
          'correctAnswer': 'Clustered index',
          'explanation': 'A clustered index physically sorts table rows, enabling fast sorted searches.'
        },
        {
          'questionText': 'What is the advantage of a clustered index?',
          'options': ['Faster range queries', 'Uses less disk space', 'Works only with B-trees', 'Supports only unique values'],
          'correctAnswer': 'Faster range queries',
          'explanation': 'Clustered indexes improve performance for range queries due to ordered data.'
        },
        {
          'questionText': 'Which of the following is true about indexing?',
          'options': ['Indexing speeds up search operations', 'Indexing slows down updates', 'Indexing requires additional storage', 'All of the above'],
          'correctAnswer': 'All of the above',
          'explanation': 'Indexing enhances searches but impacts updates and requires extra space.'
        },

        // 2. Hashing (5 questions)
        {
          'questionText': 'What is the primary purpose of hashing in databases?',
          'options': ['Sorting data', 'Searching data efficiently', 'Deleting records', 'Normalizing tables'],
          'correctAnswer': 'Searching data efficiently',
          'explanation': 'Hashing enables quick data retrieval by mapping keys to locations.'
        },
        {
          'questionText': 'Which type of hashing changes the size of the hash table dynamically?',
          'options': ['Static hashing', 'Dynamic hashing', 'Open addressing', 'Linear hashing'],
          'correctAnswer': 'Dynamic hashing',
          'explanation': 'Dynamic hashing adjusts the table size as data grows or shrinks.'
        },
        {
          'questionText': 'In static hashing, the number of buckets:',
          'options': ['Increases dynamically', 'Remains fixed', 'Decreases dynamically', 'Varies randomly'],
          'correctAnswer': 'Remains fixed',
          'explanation': 'Static hashing uses a fixed number of buckets determined at creation.'
        },
        {
          'questionText': 'Which hashing technique uses a hash function to distribute records across multiple buckets?',
          'options': ['Open hashing', 'Closed hashing', 'Chained hashing', 'Linear hashing'],
          'correctAnswer': 'Chained hashing',
          'explanation': 'Chained hashing uses linked lists in buckets to handle collisions.'
        },
        {
          'questionText': 'Which problem does hashing solve in database indexing?',
          'options': ['Sorting issues', 'Slow searches', 'Data redundancy', 'Anomaly detection'],
          'correctAnswer': 'Slow searches',
          'explanation': 'Hashing reduces search time by providing direct access to records.'
        },

        // 3. Query Processing & Optimization (5 questions)
        {
          'questionText': 'Query processing in a DBMS involves:',
          'options': ['Parsing, optimization, execution', 'Execution only', 'Storage only', 'Query writing'],
          'correctAnswer': 'Parsing, optimization, execution',
          'explanation': 'Query processing includes parsing the query, optimizing it, and executing it.'
        },
        {
          'questionText': 'Which of the following is the first step in query processing?',
          'options': ['Query execution', 'Query parsing', 'Query optimization', 'Query indexing'],
          'correctAnswer': 'Query parsing',
          'explanation': 'Parsing validates syntax and converts the query into an internal form.'
        },
        {
          'questionText': 'The main goal of query optimization is to:',
          'options': ['Minimize query execution time', 'Maximize disk usage', 'Increase query complexity', 'Slow down query execution'],
          'correctAnswer': 'Minimize query execution time',
          'explanation': 'Query optimization seeks to reduce execution time and resource usage.'
        },
        {
          'questionText': 'Which optimization technique selects the best query execution plan?',
          'options': ['Cost-based optimization', 'Rule-based optimization', 'Heuristic optimization', 'All of the above'],
          'correctAnswer': 'All of the above',
          'explanation': 'All these techniques help choose efficient execution plans.'
        },
        {
          'questionText': 'Which approach does cost-based query optimization use?',
          'options': ['Heuristic rules', 'Execution cost estimation', 'Random selection', 'Fixed execution order'],
          'correctAnswer': 'Execution cost estimation',
          'explanation': 'Cost-based optimization estimates resource costs to select the best plan.'
        },
      ],
      'DBMS_Module 4_Mock Test 2': [
        {
          'questionText': 'Which join is used when we need all matching and non-matching rows from both tables?',
          'options': ['INNER JOIN', 'LEFT JOIN', 'RIGHT JOIN', 'FULL OUTER JOIN'],
          'correctAnswer': 'FULL OUTER JOIN',
          'explanation': 'FULL OUTER JOIN includes all rows from both tables, with NULLs where unmatched.'
        },
        {
          'questionText': 'Which of the following is NOT a valid join type in SQL?',
          'options': ['Natural Join', 'Equi Join', 'Cross Join', 'Conditional Join'],
          'correctAnswer': 'Conditional Join',
          'explanation': 'Conditional Join is not a standard SQL join type.'
        },
        {
          'questionText': 'The best join method for large datasets when indexes are not available is:',
          'options': ['Nested Loop Join', 'Hash Join', 'Merge Join', 'Cross Join'],
          'correctAnswer': 'Hash Join',
          'explanation': 'Hash Join is efficient for large datasets without indexes.'
        },
        {
          'questionText': 'Merge join is most efficient when:',
          'options': ['Tables are already sorted', 'Tables are large and unordered', 'Tables have no indexes', 'Tables contain NULL values'],
          'correctAnswer': 'Tables are already sorted',
          'explanation': 'Merge Join performs best with pre-sorted tables.'
        },
        {
          'questionText': 'Which SQL clause helps optimize queries by pre-selecting only necessary rows before a join?',
          'options': ['GROUP BY', 'WHERE', 'ORDER BY', 'DISTINCT'],
          'correctAnswer': 'WHERE',
          'explanation': 'WHERE filters rows before joining, reducing processing overhead.'
        },

        // 5. Transactions & Concurrency Control (5 questions)
        {
          'questionText': 'What does the "A" in ACID properties stand for?',
          'options': ['Availability', 'Atomicity', 'Accuracy', 'Authentication'],
          'correctAnswer': 'Atomicity',
          'explanation': 'Atomicity ensures a transaction is completed fully or not at all.'
        },
        {
          'questionText': 'Which isolation level prevents dirty reads but allows non-repeatable reads?',
          'options': ['Read Uncommitted', 'Read Committed', 'Repeatable Read', 'Serializable'],
          'correctAnswer': 'Read Committed',
          'explanation': 'Read Committed prevents dirty reads but allows non-repeatable reads.'
        },
        {
          'questionText': 'What is a dirty read?',
          'options': ['Reading uncommitted data', 'Reading outdated data', 'Reading duplicate data', 'Reading locked rows'],
          'correctAnswer': 'Reading uncommitted data',
          'explanation': 'A dirty read occurs when uncommitted changes are read.'
        },
        {
          'questionText': 'Deadlocks occur when:',
          'options': ['Transactions wait for resources indefinitely', 'Transactions execute concurrently', 'A database crashes', 'Two transactions access the same data at the same time'],
          'correctAnswer': 'Transactions wait for resources indefinitely',
          'explanation': 'Deadlocks happen when transactions block each other indefinitely.'
        },
        {
          'questionText': 'Which SQL command saves all the changes made in a transaction?',
          'options': ['COMMIT', 'ROLLBACK', 'DELETE', 'SAVEPOINT'],
          'correctAnswer': 'COMMIT',
          'explanation': 'COMMIT permanently saves transaction changes.'
        },

        // 6. Performance Tuning & Query Optimization (5 questions)
        {
          'questionText': 'What is the best way to speed up SELECT queries?',
          'options': ['Increase table size', 'Normalize data excessively', 'Create appropriate indexes', 'Use multiple subqueries'],
          'correctAnswer': 'Create appropriate indexes',
          'explanation': 'Indexes significantly improve SELECT query performance.'
        },
        {
          'questionText': 'Which of the following helps in query optimization?',
          'options': ['Analyzing query execution plans', 'Using redundant data', 'Increasing database size', 'Avoiding indexes'],
          'correctAnswer': 'Analyzing query execution plans',
          'explanation': 'Execution plan analysis helps identify optimization opportunities.'
        },
        {
          'questionText': 'In cost-based query optimization, the optimizer selects the plan with:',
          'options': ['Maximum cost', 'Minimum cost', 'Random selection', 'No indexing'],
          'correctAnswer': 'Minimum cost',
          'explanation': 'Cost-based optimization chooses the least costly execution plan.'
        },
        {
          'questionText': 'Which of the following can degrade database performance?',
          'options': ['Too many indexes', 'Efficient indexing', 'Proper joins', 'Query optimization'],
          'correctAnswer': 'Too many indexes',
          'explanation': 'Excessive indexes slow down updates and consume storage.'
        },
        {
          'questionText': 'Why should we avoid unnecessary indexes?',
          'options': ['They increase query speed', 'They consume extra storage and slow down updates', 'They reduce the number of queries', 'They improve performance in all cases'],
          'correctAnswer': 'They consume extra storage and slow down updates',
          'explanation': 'Unnecessary indexes increase overhead for writes and storage.'
        }
      ],
      'DBMS_Module 5_Mock Test 1': [
        {
          'questionText': 'What is the main purpose of concurrency control in DBMS?',
          'options': ['To prevent hardware failures', 'To manage simultaneous transactions safely', 'To speed up query execution', 'To ensure database normalization'],
          'correctAnswer': 'To manage simultaneous transactions safely',
          'explanation': 'Concurrency control ensures multiple transactions execute correctly without conflicts.'
        },
        {
          'questionText': 'Which of the following is NOT a concurrency control technique?',
          'options': ['Two-phase locking', 'Timestamp ordering', 'Deadlock prevention', 'B-tree indexing'],
          'correctAnswer': 'B-tree indexing',
          'explanation': 'B-tree indexing is for efficient data retrieval, not concurrency control.'
        },
        {
          'questionText': 'Which type of lock allows multiple transactions to read a data item but prevents writes?',
          'options': ['Exclusive Lock', 'Shared Lock', 'Deadlock Lock', 'Write Lock'],
          'correctAnswer': 'Shared Lock',
          'explanation': 'Shared locks allow multiple reads but block writes.'
        },
        {
          'questionText': 'A transaction that is waiting for a resource held by another transaction results in:',
          'options': ['Commit', 'Deadlock', 'Atomicity', 'Isolation'],
          'correctAnswer': 'Deadlock',
          'explanation': 'A deadlock occurs when transactions wait indefinitely for each other’s resources.'
        },
        {
          'questionText': 'Which isolation level provides the highest level of isolation?',
          'options': ['Read Uncommitted', 'Read Committed', 'Repeatable Read', 'Serializable'],
          'correctAnswer': 'Serializable',
          'explanation': 'Serializable ensures complete isolation, preventing all concurrency issues.'
        },

        // 2. Database Recovery (5 questions)
        {
          'questionText': 'Which property of a transaction ensures that committed data is not lost due to failure?',
          'options': ['Atomicity', 'Consistency', 'Isolation', 'Durability'],
          'correctAnswer': 'Durability',
          'explanation': 'Durability guarantees that committed data persists even after a failure.'
        },
        {
          'questionText': 'What is the purpose of database recovery?',
          'options': ['To optimize query execution', 'To restore the database to a correct state after a failure', 'To delete unnecessary transactions', 'To increase the number of indexes'],
          'correctAnswer': 'To restore the database to a correct state after a failure',
          'explanation': 'Recovery restores the database to a consistent state post-failure.'
        },
        {
          'questionText': 'Which of the following recovery techniques uses logs to redo transactions?',
          'options': ['Deferred Write', 'Immediate Update', 'Checkpointing', 'Shadow Paging'],
          'correctAnswer': 'Immediate Update',
          'explanation': 'Immediate Update logs changes and applies them before commit, allowing redo.'
        },
        {
          'questionText': 'In database recovery, a checkpoint is used to:',
          'options': ['Mark a point where changes are saved to disk', 'Delete old transactions', 'Restore deleted tables', 'Improve indexing'],
          'correctAnswer': 'Mark a point where changes are saved to disk',
          'explanation': 'Checkpoints reduce recovery time by marking a consistent state.'
        },
        {
          'questionText': 'Which command is used to undo all changes made by a transaction?',
          'options': ['COMMIT', 'DELETE', 'ROLLBACK', 'SAVEPOINT'],
          'correctAnswer': 'ROLLBACK',
          'explanation': 'ROLLBACK reverses all changes made during a transaction.'
        },

        // 3. Advanced Database Concepts (5 questions)
        {
          'questionText': 'Which database model supports object-oriented concepts?',
          'options': ['Hierarchical Model', 'Relational Model', 'Object-Oriented Database Model', 'Network Model'],
          'correctAnswer': 'Object-Oriented Database Model',
          'explanation': 'OODBMS integrates object-oriented programming principles.'
        },
        {
          'questionText': 'Which of the following is a NoSQL database?',
          'options': ['MySQL', 'PostgreSQL', 'MongoDB', 'Oracle'],
          'correctAnswer': 'MongoDB',
          'explanation': 'MongoDB is a NoSQL database, unlike the others which are relational.'
        },
        {
          'questionText': 'Which type of NoSQL database is best for handling relationships between data?',
          'options': ['Key-Value Store', 'Document Store', 'Column Store', 'Graph Database'],
          'correctAnswer': 'Graph Database',
          'explanation': 'Graph databases excel at managing complex relationships.'
        },
        {
          'questionText': 'CAP theorem states that a distributed system can have at most two out of three properties. What are they?',
          'options': ['Consistency, Availability, Partition Tolerance', 'Concurrency, Atomicity, Persistence', 'Cache, Application, Processing', 'Coordination, Authentication, Protection'],
          'correctAnswer': 'Consistency, Availability, Partition Tolerance',
          'explanation': 'CAP theorem defines trade-offs in distributed systems.'
        },
        {
          'questionText': 'Which of the following is an example of a document-oriented NoSQL database?',
          'options': ['MySQL', 'MongoDB', 'Neo4j', 'Cassandra'],
          'correctAnswer': 'MongoDB',
          'explanation': 'MongoDB stores data as documents, a key feature of document-oriented NoSQL.'
        },
      ],
      'DBMS_Module 5_Mock Test 2': [
        {
          'questionText': 'Which technique is used to restrict database access based on user roles?',
          'options': ['Encryption', 'Firewalls', 'Authentication', 'Role-Based Access Control (RBAC)'],
          'correctAnswer': 'Role-Based Access Control (RBAC)',
          'explanation': 'RBAC assigns permissions based on user roles for access control.'
        },
        {
          'questionText': 'Which database security method ensures that data is unreadable without proper decryption?',
          'options': ['Authorization', 'Hashing', 'Encryption', 'Data masking'],
          'correctAnswer': 'Encryption',
          'explanation': 'Encryption transforms data into an unreadable format without a key.'
        },
        {
          'questionText': 'What is SQL Injection?',
          'options': ['A method to optimize SQL queries', 'A type of cyber attack exploiting SQL vulnerabilities', 'A process of indexing tables', 'A way to update a database automatically'],
          'correctAnswer': 'A type of cyber attack exploiting SQL vulnerabilities',
          'explanation': 'SQL Injection manipulates queries to gain unauthorized access.'
        },
        {
          'questionText': 'Which of the following is NOT a database security measure?',
          'options': ['Firewalls', 'Indexing', 'Authentication', 'Encryption'],
          'correctAnswer': 'Indexing',
          'explanation': 'Indexing improves performance, not security.'
        },
        {
          'questionText': 'Which access control model grants access based on predefined rules and permissions?',
          'options': ['Discretionary Access Control (DAC)', 'Mandatory Access Control (MAC)', 'Role-Based Access Control (RBAC)', 'All of the above'],
          'correctAnswer': 'All of the above',
          'explanation': 'DAC, MAC, and RBAC all use rules and permissions for access control.'
        },

        // 5. Cloud Databases & Big Data (5 questions)
        {
          'questionText': 'Which of the following is a cloud-based database service?',
          'options': ['Amazon RDS', 'MySQL', 'PostgreSQL', 'Oracle Database'],
          'correctAnswer': 'Amazon RDS',
          'explanation': 'Amazon RDS is a managed cloud database service.'
        },
        {
          'questionText': 'Which cloud computing model provides a fully managed database service?',
          'options': ['Infrastructure as a Service (IaaS)', 'Platform as a Service (PaaS)', 'Software as a Service (SaaS)', 'Function as a Service (FaaS)'],
          'correctAnswer': 'Platform as a Service (PaaS)',
          'explanation': 'PaaS offers managed database services with minimal user maintenance.'
        },
        {
          'questionText': 'Which big data framework is widely used for processing large-scale datasets?',
          'options': ['MongoDB', 'Hadoop', 'MySQL', 'SQL Server'],
          'correctAnswer': 'Hadoop',
          'explanation': 'Hadoop is designed for distributed processing of large datasets.'
        },
        {
          'questionText': 'Which NoSQL database is designed for high write performance in distributed systems?',
          'options': ['MongoDB', 'Cassandra', 'PostgreSQL', 'MySQL'],
          'correctAnswer': 'Cassandra',
          'explanation': 'Cassandra excels in high-write scenarios across distributed nodes.'
        },
        {
          'questionText': 'Which of the following big data tools is used for real-time data streaming?',
          'options': ['Hadoop', 'Apache Kafka', 'SQL Server', 'PostgreSQL'],
          'correctAnswer': 'Apache Kafka',
          'explanation': 'Apache Kafka handles real-time data streaming efficiently.'
        },

        // 6. Emerging Database Technologies (5 questions)
        {
          'questionText': 'Which of the following is an example of a blockchain-based database?',
          'options': ['Bitcoin Ledger', 'PostgreSQL', 'Firebase', 'Neo4j'],
          'correctAnswer': 'Bitcoin Ledger',
          'explanation': 'Bitcoin Ledger uses blockchain for decentralized data storage.'
        },
        {
          'questionText': 'Which term refers to storing data across multiple cloud platforms?',
          'options': ['Hybrid Cloud Storage', 'Multi-cloud Architecture', 'Cloud Virtualization', 'Centralized Database Storage'],
          'correctAnswer': 'Multi-cloud Architecture',
          'explanation': 'Multi-cloud Architecture distributes data across multiple cloud providers.'
        },
        {
          'questionText': 'Which of the following is a key advantage of serverless databases?',
          'options': ['Manual scaling', 'Pay-per-use pricing model', 'Static resource allocation', 'High maintenance overhead'],
          'correctAnswer': 'Pay-per-use pricing model',
          'explanation': 'Serverless databases charge based on usage, reducing costs.'
        },
        {
          'questionText': 'Which technology is used for automated machine learning in databases?',
          'options': ['AI-driven Query Optimization', 'Hadoop File System', 'Network-Based Indexing', 'Column-Oriented Storage'],
          'correctAnswer': 'AI-driven Query Optimization',
          'explanation': 'AI enhances query optimization through machine learning.'
        },
        {
          'questionText': 'Which type of database allows real-time processing of streaming data?',
          'options': ['Relational Databases', 'NoSQL Column Stores', 'In-Memory Databases', 'Object-Oriented Databases'],
          'correctAnswer': 'In-Memory Databases',
          'explanation': 'In-Memory Databases process streaming data quickly due to RAM storage.'
        }
      ],
      'DS_Module 1_Mock Test 1': [
        {
          'questionText': 'Which data structure is classified as linear?',
          'options': ['Graph', 'Tree', 'Stack', 'Heap'],
          'correctAnswer': 'Stack',
          'explanation': 'A stack is a linear data structure with a sequential order, unlike graphs or trees.'
        },
        {
          'questionText': 'How is an array best described?',
          'options': ['Mixed data type collection', 'Similar data types in contiguous memory', 'Hierarchical structure', 'Linked list variant'],
          'correctAnswer': 'Similar data types in contiguous memory',
          'explanation': 'Arrays store similar data types in consecutive memory locations for efficient access.'
        },
        {
          'questionText': 'What’s the time complexity for accessing an array element by index?',
          'options': ['O(n)', 'O(log n)', 'O(1)', 'O(n log n)'],
          'correctAnswer': 'O(1)',
          'explanation': 'Array indexing allows direct access in constant time using memory offsets.'
        },
        {
          'questionText': 'What is the index of an array’s first element?',
          'options': ['0', '1', '-1', 'None of the above'],
          'correctAnswer': '0',
          'explanation': 'In most programming languages like C, arrays are zero-indexed, starting at 0.'
        },
        {
          'questionText': 'How do you correctly declare an array in C?',
          'options': ['int array(5);', 'int array[5];', 'array int[5];', 'int array = 5;'],
          'correctAnswer': 'int array[5];',
          'explanation': 'In C, arrays are declared with the type followed by name and size in brackets.'
        },
        {
          'questionText': 'Which operation cannot be directly performed on an array?',
          'options': ['Accessing an element', 'Searching an element', 'Deleting without shifting', 'Modifying an element'],
          'correctAnswer': 'Deleting without shifting',
          'explanation': 'Deleting an element requires shifting others to maintain contiguity in arrays.'
        },
        {
          'questionText': 'What limits the maximum size of an array?',
          'options': ['Memory size', 'CPU speed', 'Programming language', 'Array type'],
          'correctAnswer': 'Memory size',
          'explanation': 'The array size is constrained by available memory in the system.'
        },
        {
          'questionText': 'How is the third element accessed in a one-dimensional array?',
          'options': ['arr[3]', 'arr[2]', 'arr(3)', 'arr(2)'],
          'correctAnswer': 'arr[2]',
          'explanation': 'With zero-based indexing, the third element is at index 2 (arr[2]).'
        },
        {
          'questionText': 'Which is NOT an advantage of using arrays?',
          'options': ['Fast index access', 'Fixed size', 'Contiguous memory', 'Supports other structures'],
          'correctAnswer': 'Fixed size',
          'explanation': 'Fixed size is a limitation, not an advantage, as it restricts flexibility.'
        },
        {
          'questionText': 'What is the term for ordering array elements?',
          'options': ['Searching', 'Sorting', 'Merging', 'Traversing'],
          'correctAnswer': 'Sorting',
          'explanation': 'Sorting arranges elements in ascending or descending order.'
        },
        {
          'questionText': 'Which algorithm is most efficient for sorting an array?',
          'options': ['Bubble Sort', 'Selection Sort', 'Merge Sort', 'Linear Search'],
          'correctAnswer': 'Merge Sort',
          'explanation': 'Merge Sort has O(n log n) complexity, outperforming simpler O(n²) sorts.'
        },
        {
          'questionText': 'What is the time complexity of Linear Search in an array?',
          'options': ['O(1)', 'O(log n)', 'O(n)', 'O(n log n)'],
          'correctAnswer': 'O(n)',
          'explanation': 'Linear Search checks each element, taking O(n) time in the worst case.'
        },
        {
          'questionText': 'What must an array be for binary search to work?',
          'options': ['Unsorted', 'Sorted', 'Randomized', 'All of the above'],
          'correctAnswer': 'Sorted',
          'explanation': 'Binary search requires a sorted array to divide and conquer efficiently.'
        },
        {
          'questionText': 'How is an element inserted at a specific array position?',
          'options': ['Assign value at index', 'Shift elements and insert', 'Delete first', 'Not possible'],
          'correctAnswer': 'Shift elements and insert',
          'explanation': 'Insertion requires shifting elements to make space at the desired position.'
        },
        {
          'questionText': 'What’s the worst-case time complexity for array insertion?',
          'options': ['O(1)', 'O(n)', 'O(log n)', 'O(n log n)'],
          'correctAnswer': 'O(n)',
          'explanation': 'Inserting at the beginning requires shifting all elements, taking O(n) time.'
        }
      ],
      'DS_Module 1_Mock Test 2': [
        {
          'questionText': 'How do dynamic arrays differ from static arrays?',
          'options': ['Not in C', 'Dynamically allocate memory', 'No memory needed', 'Use pointers only'],
          'correctAnswer': 'Dynamically allocate memory',
          'explanation': 'Dynamic arrays can resize at runtime using memory allocation functions.'
        },
        {
          'questionText': 'What defines a multidimensional array?',
          'options': ['Single-row array', 'Multiple data types', 'Multiple indices', 'None of the above'],
          'correctAnswer': 'Multiple indices',
          'explanation': 'A multidimensional array uses multiple indices (e.g., rows and columns).'
        },
        {
          'questionText': 'How many elements can a 2D array int arr[3][4] hold?',
          'options': ['3', '4', '12', '7'],
          'correctAnswer': '12',
          'explanation': 'A 3x4 array has 3 rows and 4 columns, totaling 12 elements (3 * 4).'
        },
        {
          'questionText': 'What best describes a 2D array?',
          'options': ['List of lists', 'Tree structure', 'Graph structure', 'Stack'],
          'correctAnswer': 'List of lists',
          'explanation': 'A 2D array is a collection of rows, each being a list of elements.'
        },
        {
          'questionText': 'How is memory freed for a dynamic array in C?',
          'options': ['free()', 'delete', 'malloc()', 'Automatically freed'],
          'correctAnswer': 'free()',
          'explanation': 'free() deallocates memory allocated dynamically with malloc() or calloc().'
        },
        {
          'questionText': 'What does row-major order mean in a 2D array?',
          'options': ['Row-wise storage', 'Column-wise storage', 'Sorted rows', 'Sorted columns'],
          'correctAnswer': 'Row-wise storage',
          'explanation': 'Row-major order stores elements row by row in contiguous memory.'
        },
        {
          'questionText': 'If arr[10] starts at 1000 and int is 4 bytes, what’s arr[3]’s address?',
          'options': ['1012', '1016', '1003', '1004'],
          'correctAnswer': '1016',
          'explanation': 'Address = 1000 + (3 * 4) = 1016, as each int takes 4 bytes.'
        },
        {
          'questionText': 'Which search is fastest for a sorted array?',
          'options': ['Linear Search', 'Binary Search', 'Bubble Sort', 'Merge Sort'],
          'correctAnswer': 'Binary Search',
          'explanation': 'Binary Search’s O(log n) beats Linear Search’s O(n) on sorted arrays.'
        },
        {
          'questionText': 'Which C function allocates dynamic memory?',
          'options': ['malloc()', 'alloc()', 'allocate()', 'new()'],
          'correctAnswer': 'malloc()',
          'explanation': 'malloc() allocates a specified size of memory dynamically in C.'
        },
        {
          'questionText': 'What happens when accessing an index beyond array bounds?',
          'options': ['Compilation error', 'Segmentation fault', 'Returns 0', 'Skips element'],
          'correctAnswer': 'Segmentation fault',
          'explanation': 'Out-of-bounds access can cause a segmentation fault due to invalid memory access.'
        },
        {
          'questionText': 'What’s the best-case time complexity of binary search?',
          'options': ['O(n)', 'O(log n)', 'O(1)', 'O(n log n)'],
          'correctAnswer': 'O(1)',
          'explanation': 'Best case is O(1) when the target is at the middle of the array.'
        },
        {
          'questionText': 'How many comparisons does binary search need for 16 elements?',
          'options': ['2', '4', '8', '16'],
          'correctAnswer': '4',
          'explanation': 'log₂(16) = 4; up to 4 comparisons to find an element in 16 items.'
        },
        {
          'questionText': 'What does sizeof(arr)/sizeof(arr[0]) compute in C?',
          'options': ['Total memory', 'Number of elements', 'First element address', 'None of the above'],
          'correctAnswer': 'Number of elements',
          'explanation': 'This expression divides total array size by element size to get the count.'
        },
        {
          'questionText': 'Which is NOT a searching algorithm?',
          'options': ['Linear search', 'Binary search', 'Selection sort', 'Fibonacci search'],
          'correctAnswer': 'Selection sort',
          'explanation': 'Selection sort is a sorting algorithm, not a search method.'
        },
        {
          'questionText': 'What’s the time complexity of inserting at an array’s end?',
          'options': ['O(1)', 'O(n)', 'O(log n)', 'O(n log n)'],
          'correctAnswer': 'O(1)',
          'explanation': 'Appending at the end is O(1) if space is available, no shifting needed.'
        }
      ],
      'DS_Module 2_Mock Test 1': [
        {
          'questionText': 'What defines the ordering characteristic of a stack?',
          'options': ['FIFO', 'LIFO', 'Random access', 'Priority-based'],
          'correctAnswer': 'LIFO',
          'explanation': 'A stack follows Last In, First Out (LIFO), where the last element added is removed first.'
        },
        {
          'questionText': 'Which operation is NOT typically part of stack functionality?',
          'options': ['Push', 'Pop', 'Peek', 'Enqueue'],
          'correctAnswer': 'Enqueue',
          'explanation': 'Enqueue is a queue operation; stacks use push, pop, and peek.'
        },
        {
          'questionText': 'What’s the time complexity of pushing an element onto an array-based stack?',
          'options': ['O(n)', 'O(log n)', 'O(1)', 'O(n log n)'],
          'correctAnswer': 'O(1)',
          'explanation': 'Push adds an element at the top in constant time if space is available.'
        },
        {
          'questionText': 'Which function removes an element from a stack?',
          'options': ['pop()', 'remove()', 'delete()', 'dequeue()'],
          'correctAnswer': 'pop()',
          'explanation': 'pop() removes and returns the top element of a stack.'
        },
        {
          'questionText': 'What occurs when popping from an empty stack?',
          'options': ['Removes last element', 'Returns NULL', 'Stack underflow', 'Returns -1'],
          'correctAnswer': 'Stack underflow',
          'explanation': 'Attempting to pop an empty stack causes an underflow condition.'
        },
        {
          'questionText': 'What does the ‘top’ variable indicate in a stack?',
          'options': ['Max stack size', 'Last inserted element', 'Min element', 'First inserted element'],
          'correctAnswer': 'Last inserted element',
          'explanation': 'The ‘top’ tracks the index of the most recently added element.'
        },
        {
          'questionText': 'Which data structure supports recursion implementation?',
          'options': ['Queue', 'Stack', 'Linked List', 'Heap'],
          'correctAnswer': 'Stack',
          'explanation': 'Stacks manage function call returns and local variables in recursion.'
        },
        {
          'questionText': 'Which application relies on stacks?',
          'options': ['Function calls in recursion', 'CPU Scheduling', 'Priority Queue', 'Graph Traversal'],
          'correctAnswer': 'Function calls in recursion',
          'explanation': 'Stacks store function call states during recursive execution.'
        },
        {
          'questionText': 'Which is an example of postfix notation?',
          'options': ['(A+B) * C', 'A B + C *', 'A + B * C', '* + ABC'],
          'correctAnswer': 'A B + C *',
          'explanation': 'Postfix notation places operators after operands (e.g., A B +).'
        },
        {
          'questionText': 'Which structure converts infix to postfix expressions?',
          'options': ['Queue', 'Stack', 'Linked List', 'Tree'],
          'correctAnswer': 'Stack',
          'explanation': 'A stack manages operator precedence during infix-to-postfix conversion.'
        },
        {
          'questionText': 'How long does it take to check if a stack is empty?',
          'options': ['O(1)', 'O(n)', 'O(log n)', 'O(n log n)'],
          'correctAnswer': 'O(1)',
          'explanation': 'Checking the ‘top’ index or count takes constant time.'
        },
        {
          'questionText': 'What ordering principle defines a queue?',
          'options': ['LIFO', 'FIFO', 'Random order', 'Hierarchical'],
          'correctAnswer': 'FIFO',
          'explanation': 'Queues follow First In, First Out (FIFO), removing the oldest element first.'
        },
        {
          'questionText': 'Which function removes an element from a queue?',
          'options': ['pop()', 'dequeue()', 'remove()', 'delete()'],
          'correctAnswer': 'dequeue()',
          'explanation': 'dequeue() removes and returns the front element of a queue.'
        },
        {
          'questionText': 'What happens when enqueuing to a full queue?',
          'options': ['Shifts left', 'Shifts right', 'Overflow', 'Underflow'],
          'correctAnswer': 'Overflow',
          'explanation': 'Adding to a full queue causes an overflow condition.'
        },
        {
          'questionText': 'What’s the worst-case time complexity of enqueue in an array-based queue?',
          'options': ['O(1)', 'O(n)', 'O(log n)', 'O(n log n)'],
          'correctAnswer': 'O(1)',
          'explanation': 'Enqueue is O(1) when adding to the rear, assuming space exists.'
        }
      ],
      'DS_Module 2_Mock Test 2': [
        {
          'questionText': 'What characterizes a circular queue?',
          'options': ['No element storage', 'Uses circular linked list', 'Rear connects to front', 'Stores sorted data'],
          'correctAnswer': 'Rear connects to front',
          'explanation': 'A circular queue wraps around, linking rear to front for efficient space use.'
        },
        {
          'questionText': 'How many elements can a queue of size n hold before it’s full?',
          'options': ['n-1', 'n', 'n+1', '2n'],
          'correctAnswer': 'n',
          'explanation': 'A queue of size n can store n elements before becoming full.'
        },
        {
          'questionText': 'Which queue type allows operations at both ends?',
          'options': ['Simple Queue', 'Circular Queue', 'Deque', 'Priority Queue'],
          'correctAnswer': 'Deque',
          'explanation': 'A deque (double-ended queue) supports insertion and deletion at both ends.'
        },
        {
          'questionText': 'Which queue uses priority-based ordering?',
          'options': ['Circular Queue', 'Deque', 'Priority Queue', 'Simple Queue'],
          'correctAnswer': 'Priority Queue',
          'explanation': 'Priority queues order elements by priority, not insertion order.'
        },
        {
          'questionText': 'Which operation supports Breadth-First Search (BFS) in a queue?',
          'options': ['Push', 'Pop', 'Enqueue', 'Insert'],
          'correctAnswer': 'Enqueue',
          'explanation': 'BFS uses enqueue to add nodes level by level in a queue.'
        },
        {
          'questionText': 'What’s the time complexity to check if a queue is empty?',
          'options': ['O(1)', 'O(n)', 'O(log n)', 'O(n log n)'],
          'correctAnswer': 'O(1)',
          'explanation': 'Checking front/rear pointers or count is a constant-time operation.'
        },
        {
          'questionText': 'Which queue uses a linked list with dynamic front and rear updates?',
          'options': ['Simple Queue', 'Priority Queue', 'Dynamic Queue', 'Static Queue'],
          'correctAnswer': 'Dynamic Queue',
          'explanation': 'A dynamic queue uses a linked list, adjusting pointers as needed.'
        },
        {
          'questionText': 'What does the front pointer indicate in a queue?',
          'options': ['Last inserted element', 'Next element to remove', 'First inserted element', 'Middle element'],
          'correctAnswer': 'Next element to remove',
          'explanation': 'The front pointer marks the element to be dequeued next.'
        },
        {
          'questionText': 'What’s an advantage of using a queue?',
          'options': ['Random access', 'Low memory use', 'Sequential processing', 'Dynamic allocation'],
          'correctAnswer': 'Sequential processing',
          'explanation': 'Queues ensure FIFO order, ideal for sequential task handling.'
        },
        {
          'questionText': 'What’s the time complexity of dequeuing from an array-based queue?',
          'options': ['O(1)', 'O(n)', 'O(log n)', 'O(n log n)'],
          'correctAnswer': 'O(1)',
          'explanation': 'Dequeuing from the front is O(1) with proper pointer management.'
        },
        {
          'questionText': 'Which queue restricts insertion to rear and deletion to front?',
          'options': ['Priority Queue', 'Deque', 'Linear Queue', 'Circular Queue'],
          'correctAnswer': 'Linear Queue',
          'explanation': 'A linear (simple) queue follows strict rear insertion and front deletion.'
        },
        {
          'questionText': 'Which is NOT a typical queue application?',
          'options': ['Job Scheduling', 'Call Center Systems', 'Memory Allocation', 'Function Calls in Recursion'],
          'correctAnswer': 'Function Calls in Recursion',
          'explanation': 'Recursion uses stacks, not queues; the others are queue-based.'
        },
        {
          'questionText': 'How is fullness checked in a circular queue?',
          'options': ['rear == MAX-1', 'front == rear+1', '(rear + 1) % MAX == front', 'front == MAX-1'],
          'correctAnswer': '(rear + 1) % MAX == front',
          'explanation': 'This condition checks if the next rear position wraps to the front.'
        },
        {
          'questionText': 'What’s the worst-case time complexity to search a queue?',
          'options': ['O(1)', 'O(n)', 'O(log n)', 'O(n log n)'],
          'correctAnswer': 'O(n)',
          'explanation': 'Searching requires traversing all elements in the worst case.'
        },
        {
          'questionText': 'Which operation is NOT possible in a simple queue?',
          'options': ['Traversing', 'Inserting at front', 'Deleting at rear', 'Checking fullness'],
          'correctAnswer': 'Inserting at front',
          'explanation': 'Simple queues only allow insertion at the rear, not the front.'
        }
      ],
      'DS_Module 3_Mock Test 1': [
        {
          'questionText': 'Which is NOT an advantage of linked lists compared to arrays?',
          'options': ['Dynamic size', 'Faster element access', 'Efficient insertions/deletions', 'No memory wastage'],
          'correctAnswer': 'Faster element access',
          'explanation': 'Linked lists lack direct index access, making element retrieval slower than arrays.'
        },
        {
          'questionText': 'What does each node in a singly linked list contain?',
          'options': ['Data and two pointers', 'Data and one pointer', 'Only data', 'Only pointers'],
          'correctAnswer': 'Data and one pointer',
          'explanation': 'A singly linked list node has data and a pointer to the next node.'
        },
        {
          'questionText': 'What’s the worst-case time complexity for searching in a singly linked list?',
          'options': ['O(1)', 'O(n)', 'O(log n)', 'O(n log n)'],
          'correctAnswer': 'O(n)',
          'explanation': 'Searching requires traversing the entire list in the worst case.'
        },
        {
          'questionText': 'How is a linked list typically stored in memory?',
          'options': ['Using an array', 'Using pointers', 'Using a stack', 'Using a queue'],
          'correctAnswer': 'Using pointers',
          'explanation': 'Nodes are connected via pointers, not contiguous memory like arrays.'
        },
        {
          'questionText': 'What’s the key benefit of a circular linked list over a singly linked list?',
          'options': ['Easier deletion', 'Less memory use', 'Traversal from any node', 'Easier reversal'],
          'correctAnswer': 'Traversal from any node',
          'explanation': 'Circular structure allows starting traversal from any point.'
        },
        {
          'questionText': 'Which linked list type supports bidirectional traversal?',
          'options': ['Singly linked list', 'Doubly linked list', 'Circular linked list', 'None of these'],
          'correctAnswer': 'Doubly linked list',
          'explanation': 'Doubly linked lists have pointers for both next and previous nodes.'
        },
        {
          'questionText': 'What’s the time complexity of adding a node at the start of a linked list?',
          'options': ['O(1)', 'O(n)', 'O(log n)', 'O(n log n)'],
          'correctAnswer': 'O(1)',
          'explanation': 'Inserting at the head only requires updating the head pointer.'
        },
        {
          'questionText': 'What does the head pointer signify in a linked list?',
          'options': ['Points to first node', 'Points to last node', 'Points to middle node', 'Points to NULL'],
          'correctAnswer': 'Points to first node',
          'explanation': 'The head pointer marks the entry point to the linked list.'
        },
        {
          'questionText': 'Which is NOT a recognized type of linked list?',
          'options': ['Singly linked list', 'Doubly linked list', 'Multiple linked list', 'Circular linked list'],
          'correctAnswer': 'Multiple linked list',
          'explanation': '“Multiple linked list” isn’t a standard term; the others are valid types.'
        },
        {
          'questionText': 'Which structure is used for graph adjacency lists?',
          'options': ['Stack', 'Queue', 'Linked list', 'Tree'],
          'correctAnswer': 'Linked list',
          'explanation': 'Linked lists efficiently store variable-sized adjacency lists in graphs.'
        },
        {
          'questionText': 'How many pointers does a doubly linked list node have?',
          'options': ['1', '2', '3', '4'],
          'correctAnswer': '2',
          'explanation': 'Each node has a next pointer and a previous pointer.'
        },
        {
          'questionText': 'What’s a drawback of linked lists?',
          'options': ['More memory due to pointers', 'Fixed size', 'Hard to insert/delete', 'Slow searching'],
          'correctAnswer': 'More memory due to pointers',
          'explanation': 'Pointers increase memory overhead compared to arrays.'
        },
        {
          'questionText': 'Which linked list is ideal for undo functionality?',
          'options': ['Singly linked list', 'Doubly linked list', 'Circular linked list', 'None of these'],
          'correctAnswer': 'Doubly linked list',
          'explanation': 'Bidirectional traversal supports moving back and forth for undo/redo.'
        },
        {
          'questionText': 'What does a NULL next pointer indicate?',
          'options': ['Previous node', 'First node', 'Last node', 'Error'],
          'correctAnswer': 'Last node',
          'explanation': 'A NULL next pointer marks the end of a singly linked list.'
        },
        {
          'questionText': 'Which operation is more efficient in linked lists than arrays?',
          'options': ['Random access', 'Deletion', 'Searching', 'Index retrieval'],
          'correctAnswer': 'Deletion',
          'explanation': 'Deletion in linked lists adjusts pointers, avoiding array shifting.'
        }
      ],
      'DS_Module 3_Mock Test 2': [
        {
          'questionText': 'In a circular linked list, where does the last node’s next pointer go?',
          'options': ['NULL', 'First node', 'Middle node', 'Itself'],
          'correctAnswer': 'First node',
          'explanation': 'The last node links back to the first, forming a circle.'
        },
        {
          'questionText': 'What’s the time complexity of deleting a middle node in a singly linked list?',
          'options': ['O(1)', 'O(n)', 'O(log n)', 'O(n log n)'],
          'correctAnswer': 'O(n)',
          'explanation': 'Finding the node to delete requires traversing up to n nodes.'
        },
        {
          'questionText': 'Which operation is O(1) in a doubly linked list but O(n) in a singly linked list?',
          'options': ['Searching', 'Traversal', 'Deleting last node', 'Inserting at start'],
          'correctAnswer': 'Deleting last node',
          'explanation': 'Doubly linked lists use a prev pointer for O(1) last-node deletion.'
        },
        {
          'questionText': 'Which structure does NOT typically use a linked list?',
          'options': ['Stack', 'Queue', 'Binary Search Tree', 'Hash Table with open addressing'],
          'correctAnswer': 'Hash Table with open addressing',
          'explanation': 'Open addressing uses arrays, not linked lists, unlike chaining.'
        },
        {
          'questionText': 'What does this code define? struct Node { int data; struct Node* next; };',
          'options': ['Linked list node', 'Array', 'Tree', 'Stack'],
          'correctAnswer': 'Linked list node',
          'explanation': 'It defines a node with data and a pointer, typical of linked lists.'
        },
        {
          'questionText': 'What happens when accessing a deleted linked list node?',
          'options': ['Segmentation fault', 'Returns NULL', 'Runs normally', 'Deletes next node'],
          'correctAnswer': 'Segmentation fault',
          'explanation': 'Accessing freed memory can cause a segmentation fault.'
        },
        {
          'questionText': 'How can a doubly linked list be traversed?',
          'options': ['Only forward', 'Only backward', 'Both directions', 'From last node only'],
          'correctAnswer': 'Both directions',
          'explanation': 'Next and prev pointers enable forward and backward traversal.'
        },
        {
          'questionText': 'Which is a self-referential data structure?',
          'options': ['Array', 'Linked List', 'Queue', 'Heap'],
          'correctAnswer': 'Linked List',
          'explanation': 'Nodes point to other nodes of the same type, making it self-referential.'
        },
        {
          'questionText': 'Which linked list suits browser back/forward navigation?',
          'options': ['Singly linked list', 'Doubly linked list', 'Circular linked list', 'None of these'],
          'correctAnswer': 'Doubly linked list',
          'explanation': 'Bidirectional links support moving back and forward efficiently.'
        },
        {
          'questionText': 'How is a cycle detected in a linked list?',
          'options': ['Floyd’s Cycle Detection', 'Checking NULL', 'Counting nodes', 'Reversing list'],
          'correctAnswer': 'Floyd’s Cycle Detection',
          'explanation': 'Floyd’s algorithm uses two pointers to detect loops efficiently.'
        },
        {
          'questionText': 'Which operation is faster in a doubly linked list than a singly linked list?',
          'options': ['Searching', 'Traversal', 'Random access', 'Index retrieval'],
          'correctAnswer': 'Traversal',
          'explanation': 'Bidirectional traversal is more flexible in doubly linked lists.'
        },
        {
          'questionText': 'What’s the best-case time complexity for inserting at the head of a singly linked list?',
          'options': ['O(n)', 'O(1)', 'O(log n)', 'O(n log n)'],
          'correctAnswer': 'O(1)',
          'explanation': 'Insertion at the head updates only the head pointer in constant time.'
        },
        {
          'questionText': 'What’s an efficient way to reverse a linked list?',
          'options': ['Recursion', 'Two pointers', 'Using an array', 'Using a stack'],
          'correctAnswer': 'Two pointers',
          'explanation': 'Two pointers (prev and next) reverse links iteratively in O(n) time.'
        },
        {
          'questionText': 'What’s the time complexity of appending to a singly linked list with a tail pointer?',
          'options': ['O(1)', 'O(n)', 'O(log n)', 'O(n log n)'],
          'correctAnswer': 'O(1)',
          'explanation': 'A tail pointer allows direct appends without traversal.'
        },
        {
          'questionText': 'Which linked list is used for an LRU cache?',
          'options': ['Singly linked list', 'Doubly linked list', 'Circular linked list', 'None of these'],
          'correctAnswer': 'Doubly linked list',
          'explanation': 'Doubly linked lists enable efficient movement of nodes to track usage.'
        }
      ],
      'DS_Module 4_Mock Test 1': [
        {
          'questionText': 'What’s the maximum number of children a binary tree node can have?',
          'options': ['1', '2', '3', 'Any number'],
          'correctAnswer': '2',
          'explanation': 'A binary tree restricts each node to at most two children: left and right.'
        },
        {
          'questionText': 'Which traversal visits the left subtree, then the root, then the right subtree?',
          'options': ['Preorder', 'Inorder', 'Postorder', 'Level order'],
          'correctAnswer': 'Inorder',
          'explanation': 'Inorder traversal follows left-root-right order.'
        },
        {
          'questionText': 'Which traversal yields sorted order in a Binary Search Tree (BST)?',
          'options': ['Preorder', 'Inorder', 'Postorder', 'Level order'],
          'correctAnswer': 'Inorder',
          'explanation': 'Inorder traversal of a BST visits nodes in ascending order.'
        },
        {
          'questionText': 'Which is NOT a self-balancing binary search tree?',
          'options': ['AVL tree', 'Red-Black tree', 'B-tree', 'Binary Search Tree (BST)'],
          'correctAnswer': 'Binary Search Tree (BST)',
          'explanation': 'A plain BST doesn’t self-balance; the others maintain balance.'
        },
        {
          'questionText': 'What’s the time complexity of searching in a balanced BST?',
          'options': ['O(1)', 'O(n)', 'O(log n)', 'O(n log n)'],
          'correctAnswer': 'O(log n)',
          'explanation': 'Balanced BSTs halve the search space each step, yielding O(log n).'
        },
        {
          'questionText': 'Which BST operation is most costly in the worst case?',
          'options': ['Insertion', 'Searching', 'Deletion', 'Traversal'],
          'correctAnswer': 'Deletion',
          'explanation': 'Deletion may require rebalancing or finding a successor, making it complex.'
        },
        {
          'questionText': 'What’s the worst-case search time in an unbalanced BST?',
          'options': ['O(1)', 'O(log n)', 'O(n)', 'O(n log n)'],
          'correctAnswer': 'O(n)',
          'explanation': 'An unbalanced BST can degrade to a linear chain, requiring O(n) time.'
        },
        {
          'questionText': 'Which tree keeps subtree height difference at most 1?',
          'options': ['Red-Black Tree', 'AVL Tree', 'Binary Search Tree', 'B-tree'],
          'correctAnswer': 'AVL Tree',
          'explanation': 'AVL trees strictly enforce a height difference of 1 or less.'
        },
        {
          'questionText': 'Which tree is optimal for databases and file systems?',
          'options': ['AVL Tree', 'B-tree', 'Red-Black Tree', 'Splay Tree'],
          'correctAnswer': 'B-tree',
          'explanation': 'B-trees support multi-node branching, ideal for disk-based storage.'
        },
        {
          'questionText': 'How many leaves does a full binary tree with n internal nodes have?',
          'options': ['n', 'n + 1', 'n - 1', '2n'],
          'correctAnswer': 'n + 1',
          'explanation': 'In a full binary tree, leaves = internal nodes + 1.'
        },
        {
          'questionText': 'What’s the minimum height of a binary tree with n nodes?',
          'options': ['O(n)', 'O(log n)', 'O(n log n)', 'O(1)'],
          'correctAnswer': 'O(log n)',
          'explanation': 'A balanced binary tree achieves minimum height of log₂(n+1).'
        },
        {
          'questionText': 'Which traversal evaluates expressions in an expression tree?',
          'options': ['Preorder', 'Inorder', 'Postorder', 'Level order'],
          'correctAnswer': 'Postorder',
          'explanation': 'Postorder (left-right-root) computes operands before operators.'
        },
        {
          'questionText': 'What’s a key advantage of Red-Black Trees over AVL Trees?',
          'options': ['Strict balancing', 'Fewer rotations', 'Allows duplicates', 'Simpler implementation'],
          'correctAnswer': 'Fewer rotations',
          'explanation': 'Red-Black Trees relax balance rules, reducing rotation frequency.'
        },
        {
          'questionText': 'What’s the maximum degree of a binary tree node?',
          'options': ['1', '2', '3', '4'],
          'correctAnswer': '2',
          'explanation': 'Degree is the number of children; binary trees cap at 2.'
        },
        {
          'questionText': 'Which statement about binary trees is TRUE?',
          'options': ['All are full', 'All BSTs are binary trees', 'All are balanced', 'Must be complete'],
          'correctAnswer': 'All BSTs are binary trees',
          'explanation': 'A BST is a specialized binary tree with ordering properties.'
        }
      ],
      'DS_Module 4_Mock Test 2': [
        {
          'questionText': 'Which structure best represents a graph?',
          'options': ['Array', 'Stack', 'Linked List', 'Adjacency List'],
          'correctAnswer': 'Adjacency List',
          'explanation': 'Adjacency lists efficiently store graph edges, especially for sparse graphs.'
        },
        {
          'questionText': 'What’s a graph with no cycles called?',
          'options': ['Directed Graph', 'Undirected Graph', 'Tree', 'Weighted Graph'],
          'correctAnswer': 'Tree',
          'explanation': 'A tree is an acyclic, connected graph.'
        },
        {
          'questionText': 'Which describes a Depth-First Search (DFS) traversal?',
          'options': ['Left -> Right -> Root', 'Root -> Left -> Right', 'Stack-based', 'Queue-based'],
          'correctAnswer': 'Stack-based',
          'explanation': 'DFS uses a stack (implicitly via recursion) to explore deeply.'
        },
        {
          'questionText': 'What’s the worst-case time complexity of BFS with V vertices and E edges?',
          'options': ['O(V)', 'O(V + E)', 'O(E)', 'O(VE)'],
          'correctAnswer': 'O(V + E)',
          'explanation': 'BFS visits all vertices and edges once using a queue.'
        },
        {
          'questionText': 'Which algorithm finds the shortest path in a graph with positive weights?',
          'options': ['DFS', 'BFS', 'Dijkstra’s Algorithm', 'Prim’s Algorithm'],
          'correctAnswer': 'Dijkstra’s Algorithm',
          'explanation': 'Dijkstra’s computes shortest paths from a source with non-negative weights.'
        },
        {
          'questionText': 'Which algorithm constructs a Minimum Spanning Tree (MST)?',
          'options': ['Kruskal’s Algorithm', 'Bellman-Ford', 'Floyd-Warshall', 'A*'],
          'correctAnswer': 'Kruskal’s Algorithm',
          'explanation': 'Kruskal’s builds an MST by adding edges in sorted order.'
        },
        {
          'questionText': 'Which algorithm is NOT for shortest path finding?',
          'options': ['Dijkstra’s', 'Floyd-Warshall', 'Prim’s', 'Bellman-Ford'],
          'correctAnswer': 'Prim’s',
          'explanation': 'Prim’s finds an MST, not shortest paths.'
        },
        {
          'questionText': 'Which graph representation saves space for sparse graphs?',
          'options': ['Adjacency Matrix', 'Adjacency List', 'Incidence Matrix', 'Linked Matrix'],
          'correctAnswer': 'Adjacency List',
          'explanation': 'Adjacency lists use less space than matrices for sparse graphs.'
        },
        {
          'questionText': 'Which algorithm detects cycles in a directed graph?',
          'options': ['Dijkstra’s', 'Floyd-Warshall', 'DFS', 'Prim’s'],
          'correctAnswer': 'DFS',
          'explanation': 'DFS detects cycles by tracking back edges during traversal.'
        },
        {
          'questionText': 'What’s the time complexity of Kruskal’s with Union-Find and path compression?',
          'options': ['O(E log V)', 'O(V log V)', 'O(V²)', 'O(E²)'],
          'correctAnswer': 'O(E log V)',
          'explanation': 'Sorting edges dominates, with near-linear Union-Find operations.'
        },
        {
          'questionText': 'Which structure optimizes Dijkstra’s Algorithm?',
          'options': ['Queue', 'Stack', 'Priority Queue', 'Linked List'],
          'correctAnswer': 'Priority Queue',
          'explanation': 'A priority queue efficiently selects the next closest vertex.'
        },
        {
          'questionText': 'Which statement about graphs is FALSE?',
          'options': ['Trees are graphs', 'Graphs can have cycles', 'Directed graphs convert to undirected', 'Connected graphs have spanning trees'],
          'correctAnswer': 'Directed graphs convert to undirected',
          'explanation': 'Directionality can’t always be ignored; conversion isn’t universal.'
        },
        {
          'questionText': 'What’s an advantage of adjacency lists over matrices?',
          'options': ['Less space for sparse graphs', 'More space needed', 'Faster edge lookups', 'Can’t handle weights'],
          'correctAnswer': 'Less space for sparse graphs',
          'explanation': 'Adjacency lists scale better with fewer edges than matrices.'
        },
        {
          'questionText': 'Which is NOT a graph traversal algorithm?',
          'options': ['DFS', 'BFS', 'Topological Sorting', 'QuickSort'],
          'correctAnswer': 'QuickSort',
          'explanation': 'QuickSort is a sorting algorithm, not for graph traversal.'
        },
        {
          'questionText': 'What’s the time complexity to check adjacency in an adjacency matrix?',
          'options': ['O(1)', 'O(n)', 'O(log n)', 'O(n log n)'],
          'correctAnswer': 'O(1)',
          'explanation': 'Matrix lookups use direct indexing, taking constant time.'
        }
      ],
      'DS_Module 5_Mock Test 1': [
        {
          'questionText': 'Which sorting algorithm has a worst-case time complexity of O(n²)?',
          'options': ['Merge Sort', 'Quick Sort', 'Heap Sort', 'Bubble Sort'],
          'correctAnswer': 'Bubble Sort',
          'explanation': 'Bubble Sort compares adjacent elements, leading to O(n²) in the worst case.'
        },
        {
          'questionText': 'Which sorting method uses a divide-and-conquer strategy?',
          'options': ['Insertion Sort', 'Selection Sort', 'Quick Sort', 'Bubble Sort'],
          'correctAnswer': 'Quick Sort',
          'explanation': 'Quick Sort partitions the array and recursively sorts subarrays.'
        },
        {
          'questionText': 'What’s the worst-case time complexity of Merge Sort?',
          'options': ['O(n)', 'O(n²)', 'O(n log n)', 'O(log n)'],
          'correctAnswer': 'O(n log n)',
          'explanation': 'Merge Sort divides and merges in O(n log n) time, regardless of input.'
        },
        {
          'questionText': 'Which sorting algorithm excels with nearly sorted data?',
          'options': ['Bubble Sort', 'Insertion Sort', 'Selection Sort', 'Merge Sort'],
          'correctAnswer': 'Insertion Sort',
          'explanation': 'Insertion Sort performs well (near O(n)) on nearly sorted arrays.'
        },
        {
          'questionText': 'Which algorithm repeatedly picks the smallest element to sort?',
          'options': ['Bubble Sort', 'Selection Sort', 'Merge Sort', 'Quick Sort'],
          'correctAnswer': 'Selection Sort',
          'explanation': 'Selection Sort finds the minimum and places it at the front iteratively.'
        },
        {
          'questionText': 'Which sorting algorithm lacks stability?',
          'options': ['Merge Sort', 'Bubble Sort', 'Quick Sort', 'Insertion Sort'],
          'correctAnswer': 'Quick Sort',
          'explanation': 'Quick Sort’s partitioning can swap equal elements, breaking stability.'
        },
        {
          'questionText': 'Which sorting algorithm achieves O(n) in its best case?',
          'options': ['Quick Sort', 'Merge Sort', 'Bubble Sort', 'Insertion Sort'],
          'correctAnswer': 'Insertion Sort',
          'explanation': 'Insertion Sort runs in O(n) when the array is already sorted.'
        },
        {
          'questionText': 'Which algorithm is most efficient for large datasets?',
          'options': ['Bubble Sort', 'Selection Sort', 'Merge Sort', 'Insertion Sort'],
          'correctAnswer': 'Merge Sort',
          'explanation': 'Merge Sort’s O(n log n) makes it efficient for large data.'
        },
        {
          'questionText': 'Which sorting method relies on a max heap?',
          'options': ['Merge Sort', 'Quick Sort', 'Heap Sort', 'Bubble Sort'],
          'correctAnswer': 'Heap Sort',
          'explanation': 'Heap Sort builds a max heap and extracts elements to sort.'
        },
        {
          'questionText': 'Which sorting algorithm avoids recursion?',
          'options': ['Merge Sort', 'Quick Sort', 'Heap Sort', 'None of the above'],
          'correctAnswer': 'Heap Sort',
          'explanation': 'Heap Sort uses iterative heap operations, not recursion.'
        },
        {
          'questionText': 'What’s the main drawback of Quick Sort?',
          'options': ['Extra memory', 'Poor for small data', 'O(n²) worst case', 'Uses recursion'],
          'correctAnswer': 'O(n²) worst case',
          'explanation': 'Quick Sort degrades to O(n²) with poor pivot choices (e.g., sorted array).'
        },
        {
          'questionText': 'Which sorting algorithm has the best average-case performance?',
          'options': ['Bubble Sort', 'Merge Sort', 'Quick Sort', 'Selection Sort'],
          'correctAnswer': 'Quick Sort',
          'explanation': 'Quick Sort’s average case is O(n log n) with good pivot selection.'
        },
        {
          'questionText': 'Which algorithm is ideal for external sorting?',
          'options': ['Heap Sort', 'Merge Sort', 'Quick Sort', 'Insertion Sort'],
          'correctAnswer': 'Merge Sort',
          'explanation': 'Merge Sort handles large data on disk efficiently with merging.'
        },
        {
          'questionText': 'Which sorting method minimizes swaps in the worst case?',
          'options': ['Bubble Sort', 'Selection Sort', 'Quick Sort', 'Merge Sort'],
          'correctAnswer': 'Selection Sort',
          'explanation': 'Selection Sort makes at most n-1 swaps, fewer than Bubble Sort.'
        },
        {
          'questionText': 'What’s the worst-case time complexity of Heap Sort?',
          'options': ['O(n)', 'O(n log n)', 'O(n²)', 'O(log n)'],
          'correctAnswer': 'O(n log n)',
          'explanation': 'Heap Sort builds a heap and extracts n elements, each O(log n).'
        }
      ],
      'DS_Module 5_Mock Test 2': [
        {
          'questionText': 'Which search method halves the search space repeatedly?',
          'options': ['Linear Search', 'Binary Search', 'Depth-First Search', 'Breadth-First Search'],
          'correctAnswer': 'Binary Search',
          'explanation': 'Binary Search divides the sorted array in half each step.'
        },
        {
          'questionText': 'What’s the worst-case time complexity of Binary Search?',
          'options': ['O(1)', 'O(n)', 'O(log n)', 'O(n log n)'],
          'correctAnswer': 'O(log n)',
          'explanation': 'Binary Search reduces the search space logarithmically.'
        },
        {
          'questionText': 'Which is NOT required for Binary Search?',
          'options': ['Sorted array', 'Random access', 'Descending order', 'None of these'],
          'correctAnswer': 'Descending order',
          'explanation': 'Binary Search needs a sorted array, but order (asc/desc) is flexible.'
        },
        {
          'questionText': 'What’s the worst-case time complexity of Linear Search?',
          'options': ['O(1)', 'O(log n)', 'O(n)', 'O(n log n)'],
          'correctAnswer': 'O(n)',
          'explanation': 'Linear Search checks every element in the worst case.'
        },
        {
          'questionText': 'Which search is best for a linked list?',
          'options': ['Binary Search', 'Linear Search', 'Depth-First Search', 'Fibonacci Search'],
          'correctAnswer': 'Linear Search',
          'explanation': 'Linked lists lack random access, making Linear Search the practical choice.'
        },
        {
          'questionText': 'Which search method is used in hash tables?',
          'options': ['Binary Search', 'Linear Search', 'Hashing', 'DFS'],
          'correctAnswer': 'Hashing',
          'explanation': 'Hashing maps keys to indices for O(1) average-case lookups.'
        },
        {
          'questionText': 'What advantage does Interpolation Search have over Binary Search?',
          'options': ['Faster on uniform data', 'Works on unsorted data', 'Lower worst-case complexity', 'Less memory'],
          'correctAnswer': 'Faster on uniform data',
          'explanation': 'Interpolation Search estimates position, excelling with uniform distributions.'
        },
        {
          'questionText': 'Which search suits sorted, frequently updated datasets?',
          'options': ['Binary Search', 'Jump Search', 'Fibonacci Search', 'Linear Search'],
          'correctAnswer': 'Jump Search',
          'explanation': 'Jump Search balances efficiency and adaptability for changing data.'
        },
        {
          'questionText': 'Which algorithm supports auto-suggestions in search engines?',
          'options': ['Linear Search', 'Binary Search', 'Trie-based Search', 'Fibonacci Search'],
          'correctAnswer': 'Trie-based Search',
          'explanation': 'Tries efficiently store and retrieve prefixes for suggestions.'
        },
        {
          'questionText': 'Which search uses a divide-and-conquer approach?',
          'options': ['Linear Search', 'Binary Search', 'Hashing', 'DFS'],
          'correctAnswer': 'Binary Search',
          'explanation': 'Binary Search splits the search space recursively.'
        },
        {
          'questionText': 'Which search performs best on large, sorted datasets?',
          'options': ['Linear Search', 'Binary Search', 'BFS', 'Quick Search'],
          'correctAnswer': 'Binary Search',
          'explanation': 'Binary Search’s O(log n) is ideal for large, sorted data.'
        },
        {
          'questionText': 'What’s the worst-case time complexity of Jump Search?',
          'options': ['O(1)', 'O(n)', 'O(√n)', 'O(n log n)'],
          'correctAnswer': 'O(√n)',
          'explanation': 'Jump Search jumps √n steps, then backtracks, totaling O(√n).'
        },
        {
          'questionText': 'Which is NOT a searching algorithm?',
          'options': ['Binary Search', 'Linear Search', 'Bubble Sort', 'Jump Search'],
          'correctAnswer': 'Bubble Sort',
          'explanation': 'Bubble Sort is a sorting algorithm, not a search method.'
        },
        {
          'questionText': 'Which search is suited for large datasets with limited memory?',
          'options': ['BFS', 'DFS', 'External Searching', 'Jump Search'],
          'correctAnswer': 'External Searching',
          'explanation': 'External Searching optimizes for disk-based data with minimal RAM.'
        },
        {
          'questionText': 'What’s the best-case time complexity of Binary Search?',
          'options': ['O(1)', 'O(log n)', 'O(n)', 'O(n log n)'],
          'correctAnswer': 'O(1)',
          'explanation': 'Best case occurs when the target is at the middle on the first check.'
        }
      ],
      'FLAT_Module 1_Mock Test 1': [
        {
          'questionText': 'What’s the term for a language that no DFA can recognize?',
          'options': ['Regular Language', 'Non-Regular Language', 'May be Regular', 'Cannot be determined'],
          'correctAnswer': 'Non-Regular Language',
          'explanation': 'Non-regular languages exceed the expressive power of DFAs (e.g., context-free languages).'
        },
        {
          'questionText': 'Which is NOT a valid way to represent a DFA?',
          'options': ['Transition graph', 'Transition table', 'C code', 'Truth table'],
          'correctAnswer': 'Truth table',
          'explanation': 'Truth tables are for Boolean logic, not DFA state transitions.'
        },
        {
          'questionText': 'Which string would a DFA rejecting strings ending with ‘101’ NOT accept?',
          'options': ['1101101', '101', '1001', '1110101'],
          'correctAnswer': '1001',
          'explanation': 'A DFA for strings ending in ‘101’ rejects ‘1001’ as it doesn’t end with ‘101’.'
        },
        {
          'questionText': 'Can a DFA identify palindromes?',
          'options': ['Yes', 'No', 'Yes, with ∑*', 'Cannot be determined'],
          'correctAnswer': 'No',
          'explanation': 'Palindromes (e.g., 0ⁿ1ⁿ0ⁿ) are not regular; DFAs lack memory for this.'
        },
        {
          'questionText': 'What’s a defining feature of a DFA?',
          'options': ['Multiple transitions per symbol', 'ε-transitions', 'One transition per symbol per state', 'No final state'],
          'correctAnswer': 'One transition per symbol per state',
          'explanation': 'DFAs are deterministic, requiring exactly one transition per input per state.'
        },
        {
          'questionText': 'Which element is NOT part of a DFA’s tuple?',
          'options': ['Input alphabet', 'Set of states', 'Stack', 'Transition function'],
          'correctAnswer': 'Stack',
          'explanation': 'A DFA’s tuple is (Q, Σ, δ, q₀, F); stacks are for PDAs, not DFAs.'
        },
        {
          'questionText': 'Which language can a DFA NOT recognize?',
          'options': ['Even number of 0s', 'Palindromes', 'Ends with 01', 'At most two 1s'],
          'correctAnswer': 'Palindromes',
          'explanation': 'Palindromes require memory beyond DFA capabilities; others are regular.'
        },
        {
          'questionText': 'Is there a DFA for L = {0ⁿ1ⁿ | n ≥ 1}?',
          'options': ['Yes', 'No'],
          'correctAnswer': 'No',
          'explanation': 'This language is context-free, not regular, due to its counting requirement.'
        },
        {
          'questionText': 'Which technique proves a language is non-regular?',
          'options': ['Pumping Lemma', 'Closure properties', 'Transition graph', 'NFA'],
          'correctAnswer': 'Pumping Lemma',
          'explanation': 'The Pumping Lemma tests if a language violates regular language properties.'
        },
        {
          'questionText': 'Which statement is FALSE about NFAs?',
          'options': ['Multiple transitions allowed', 'ε-transitions possible', 'Every NFA has a DFA equivalent', 'DFA has more states than its NFA'],
          'correctAnswer': 'DFA has more states than its NFA',
          'explanation': 'An NFA-to-DFA conversion may increase states, not the reverse.'
        },
        {
          'questionText': 'What’s NOT an advantage of NFA over DFA?',
          'options': ['More expressive power', 'Easier transitions', 'Compact representation', 'Simpler construction'],
          'correctAnswer': 'More expressive power',
          'explanation': 'NFAs and DFAs recognize the same (regular) languages; power is equal.'
        },
        {
          'questionText': 'Which automaton has the greatest computational power?',
          'options': ['DFA', 'NFA', 'ε-NFA', 'Turing Machine'],
          'correctAnswer': 'Turing Machine',
          'explanation': 'Turing Machines recognize all computable languages, beyond regular ones.'
        },
        {
          'questionText': 'Which statement is TRUE about automata?',
          'options': ['NFA and ε-NFA differ in languages', 'Every ε-NFA converts to a DFA', 'DFA outpowers NFA', 'NFA is more powerful'],
          'correctAnswer': 'Every ε-NFA converts to a DFA',
          'explanation': 'ε-NFAs, NFAs, and DFAs all recognize regular languages and are convertible.'
        },
        {
          'questionText': 'Which is NOT a component of an ε-NFA?',
          'options': ['Set of states', 'Transition function', 'Input alphabet', 'Stack'],
          'correctAnswer': 'Stack',
          'explanation': 'ε-NFAs don’t use stacks; they extend NFAs with ε-transitions.'
        },
        {
          'questionText': 'How are ε-transitions removed from an ε-NFA?',
          'options': ['Subset Construction', 'ε-Closure', 'Pumping Lemma', 'Thompson’s Construction'],
          'correctAnswer': 'ε-Closure',
          'explanation': 'ε-Closure computes reachable states via ε-transitions for conversion.'
        }
      ],
      'FLAT_Module 1_Mock Test 2': [
        {
          'questionText': 'What distinguishes an NFA from a DFA?',
          'options': ['DFA recognizes more', 'NFA allows multiple transitions', 'NFA can’t handle regular languages', 'DFA is non-deterministic'],
          'correctAnswer': 'NFA allows multiple transitions',
          'explanation': 'NFAs can have multiple or no transitions per input, unlike DFAs.'
        },
        {
          'questionText': 'What’s the worst-case time complexity to simulate an NFA with n states on a string of length m?',
          'options': ['O(n)', 'O(nm)', 'O(2ⁿm)', 'O(m log n)'],
          'correctAnswer': 'O(2ⁿm)',
          'explanation': 'Simulating all possible paths (exponential states) takes O(2ⁿ) per character.'
        },
        {
          'questionText': 'How many states are minimally required in a DFA for strings ending in ‘01’?',
          'options': ['1', '2', '3', '4'],
          'correctAnswer': '3',
          'explanation': 'Three states track the last two bits: not ending in 0, ending in 0, ending in 01.'
        },
        {
          'questionText': 'Which method minimizes a DFA?',
          'options': ['ε-Closure', 'Subset Construction', 'State Equivalence Partitioning', 'Pumping Lemma'],
          'correctAnswer': 'State Equivalence Partitioning',
          'explanation': 'This merges indistinguishable states to minimize the DFA.'
        },
        {
          'questionText': 'What’s the maximum number of states in a DFA equivalent to an NFA with n states?',
          'options': ['n', '2ⁿ', 'n²', 'log n'],
          'correctAnswer': '2ⁿ',
          'explanation': 'Subset construction may create a state for each subset of NFA states.'
        },
        {
          'questionText': 'Which is FALSE about finite automata?',
          'options': ['DFA as NFA', 'NFA as DFA', 'DFA more powerful than NFA', 'Both recognize regular languages'],
          'correctAnswer': 'DFA more powerful than NFA',
          'explanation': 'DFA and NFA have equal power, recognizing all regular languages.'
        },
        {
          'questionText': 'When is a DFA considered minimal?',
          'options': ['No redundant states', 'No final states', 'Max states', 'Multiple start states'],
          'correctAnswer': 'No redundant states',
          'explanation': 'A minimal DFA has no equivalent states, reducing it to the smallest form.'
        },
        {
          'questionText': 'What does the Myhill-Nerode theorem assist with?',
          'options': ['Counting DFA states', 'Proving regularity', 'Building Turing Machines', 'Defining CFGs'],
          'correctAnswer': 'Proving regularity',
          'explanation': 'It determines if a language is regular by state distinguishability.'
        },
        {
          'questionText': 'Which language is NOT regular?',
          'options': ['Equal 0s and 1s', 'At most two 1s', 'Odd 0s', 'Ends with 101'],
          'correctAnswer': 'Equal 0s and 1s',
          'explanation': 'Equal 0s and 1s requires counting, making it non-regular.'
        },
        {
          'questionText': 'Which statement about regular languages is TRUE?',
          'options': ['All finite are regular', 'All infinite are regular', 'Need a stack', 'Must be context-sensitive'],
          'correctAnswer': 'All finite are regular',
          'explanation': 'Finite languages are regular as they can be encoded in a DFA.'
        },
        {
          'questionText': 'A language is regular if it’s recognized by which automaton?',
          'options': ['DFA', 'PDA', 'Turing Machine', 'CFG'],
          'correctAnswer': 'DFA',
          'explanation': 'Regular languages are precisely those accepted by DFAs (or NFAs).'
        },
        {
          'questionText': 'Which operation is NOT closed under regular languages?',
          'options': ['Union', 'Intersection', 'Complement', 'None of these'],
          'correctAnswer': 'None of these',
          'explanation': 'Regular languages are closed under union, intersection, and complement.'
        },
        {
          'questionText': 'What’s the minimum number of states for a DFA accepting binary strings of length ≤ 3?',
          'options': ['4', '3', '5', '6'],
          'correctAnswer': '4',
          'explanation': 'States for lengths 0, 1, 2, and 3 (or a trap state) require at least 4.'
        },
        {
          'questionText': 'When is a DFA considered complete?',
          'options': ['Transitions for all symbols', 'Multiple start states', 'No final states', 'No dead states'],
          'correctAnswer': 'Transitions for all symbols',
          'explanation': 'A complete DFA defines a transition for every state-symbol pair.'
        },
        {
          'questionText': 'Which language class do DFAs recognize?',
          'options': ['Regular', 'Context-Free', 'Recursive', 'Recursively Enumerable'],
          'correctAnswer': 'Regular',
          'explanation': 'DFAs define regular languages, the simplest class in the Chomsky hierarchy.'
        }
      ],
      'FLAT_Module 2_Mock Test 1': [
        {
          'questionText': 'Which option is NOT a valid regular expression?',
          'options': ['(0+1)*', '01', '(01)*+ε', '(0+1)++'],
          'correctAnswer': '(0+1)++',
          'explanation': 'Double ++ isn’t a standard operator in regular expressions; others are valid.'
        },
        {
          'questionText': 'Which operation is NOT part of regular expression syntax?',
          'options': ['Concatenation', 'Complementation', 'Union', 'Kleene Star'],
          'correctAnswer': 'Complementation',
          'explanation': 'Regular expressions don’t directly support complement; it’s a closure property.'
        },
        {
          'questionText': 'Which regular expression matches even-length strings over {a, b}?',
          'options': ['(a+b)(a+b)*', '(a+b)*', '(aa+bb)*', '(a+b)(aa+bb)*'],
          'correctAnswer': '(a+b)(a+b)*',
          'explanation': 'Pairs two symbols repeatedly, ensuring even length.'
        },
        {
          'questionText': 'Which regular expression represents binary strings starting and ending with the same symbol?',
          'options': ['0(0+1)*0 + 1(0+1)*1', '(01)*', '(00+11)*', '0+1'],
          'correctAnswer': '0(0+1)*0 + 1(0+1)*1',
          'explanation': 'Ensures strings start and end with 0 or 1, allowing any middle content.'
        },
        {
          'questionText': 'Which language cannot be defined by a regular expression?',
          'options': ['Equal 0s and 1s', 'Contains "101"', 'Even length', 'Ends in "00"'],
          'correctAnswer': 'Equal 0s and 1s',
          'explanation': 'Counting equal 0s and 1s is non-regular; others are regular patterns.'
        },
        {
          'questionText': 'How many states are minimally needed in a DFA for (01)*?',
          'options': ['1', '2', '3', '4'],
          'correctAnswer': '3',
          'explanation': 'Tracks empty string, ends in 0, ends in 01; three states suffice.'
        },
        {
          'questionText': 'Which regular expression denotes {ε, 0, 00, 000, ...}?',
          'options': ['0*', '0+', '(0+1)*', '(00)*'],
          'correctAnswer': '0*',
          'explanation': '0* generates zero or more 0s, including ε.'
        },
        {
          'questionText': 'Which language can a regular expression represent?',
          'options': ['Palindromes', '{ww | w ∈ {0,1}*}', 'At least one 1', 'Equal 0s and 1s'],
          'correctAnswer': 'At least one 1',
          'explanation': 'Simple pattern (0+1)*1(0+1)* is regular; others are not.'
        },
        {
          'questionText': 'What’s the main purpose of the Pumping Lemma?',
          'options': ['Prove regularity', 'Prove non-regularity', 'Build a DFA', 'Create a regex'],
          'correctAnswer': 'Prove non-regularity',
          'explanation': 'It shows if a language violates regular properties by pumping.'
        },
        {
          'questionText': 'Which is NOT a step in using the Pumping Lemma?',
          'options': ['Pick a string', 'Split into three parts', 'Pump the middle', 'Convert to DFA'],
          'correctAnswer': 'Convert to DFA',
          'explanation': 'Pumping Lemma tests regularity, not DFA construction.'
        },
        {
          'questionText': 'Which language is NOT regular?',
          'options': ['Contains "101"', 'Equal 0s and 1s', 'Starts with 1', 'Ends with "00"'],
          'correctAnswer': 'Equal 0s and 1s',
          'explanation': 'Requires counting, non-regular; others are simple patterns.'
        },
        {
          'questionText': 'Which language can the Pumping Lemma prove non-regular?',
          'options': ['{0ⁿ1ⁿ | n ≥ 0}', '{0+1}*', 'At most two 1s', 'Ends in "101"'],
          'correctAnswer': '{0ⁿ1ⁿ | n ≥ 0}',
          'explanation': 'Pumping disrupts equal counts; others are regular.'
        },
        {
          'questionText': 'Which is NOT a property of regular languages?',
          'options': ['Union closure', 'Intersection closure', 'Complement closure', 'Symbol balancing'],
          'correctAnswer': 'Symbol balancing',
          'explanation': 'Balancing (e.g., equal 0s and 1s) is non-regular; others are closed.'
        },
        {
          'questionText': 'Which operation might make a regular language non-regular?',
          'options': ['Concatenation', 'Kleene Star', 'Intersection', 'None of these'],
          'correctAnswer': 'None of these',
          'explanation': 'All listed operations preserve regularity.'
        },
        {
          'questionText': 'Which operations are closed under regular languages?',
          'options': ['Complement', 'Intersection', 'Difference', 'All of these'],
          'correctAnswer': 'All of these',
          'explanation': 'Regular languages are closed under complement, intersection, and difference.'
        }
      ],
      'FLAT_Module 2_Mock Test 2': [
        {
          'questionText': 'If L1 and L2 are regular, which must also be regular?',
          'options': ['L1 ∪ L2', 'L1 ∩ L2', 'L1 - L2', 'All of these'],
          'correctAnswer': 'All of these',
          'explanation': 'Union, intersection, and difference preserve regularity.'
        },
        {
          'questionText': 'Which operation maintains the regularity of a language?',
          'options': ['Reversal', 'Palindromic checking', 'Occurrence counting', 'None of these'],
          'correctAnswer': 'Reversal',
          'explanation': 'Reversal is closed for regular languages; others are non-regular properties.'
        },
        {
          'questionText': 'What’s always true about the complement of a regular language?',
          'options': ['Regular', 'Non-Regular', 'Context-Free', 'Recursive'],
          'correctAnswer': 'Regular',
          'explanation': 'Complement closure ensures the result is regular.'
        },
        {
          'questionText': 'If a DFA accepts a language, what accepts its complement?',
          'options': ['An NFA', 'Another DFA', 'A Turing Machine', 'A PDA'],
          'correctAnswer': 'Another DFA',
          'explanation': 'Swap accepting and non-accepting states to get a DFA for the complement.'
        },
        {
          'questionText': 'Which problem is decidable for regular languages?',
          'options': ['Does DFA accept all strings?', 'Are two DFAs equivalent?', 'Does DFA accept nothing?', 'All of these'],
          'correctAnswer': 'All of these',
          'explanation': 'All are decidable via DFA analysis (e.g., reachability, minimization).'
        },
        {
          'questionText': 'What’s a key property of regular languages?',
          'options': ['Recognized by DFA', 'Need a stack', 'More powerful than CFGs', 'Cannot be complemented'],
          'correctAnswer': 'Recognized by DFA',
          'explanation': 'Regular languages are defined by DFA/NFA recognition.'
        },
        {
          'questionText': 'What’s the worst-case time complexity to check DFA string acceptance?',
          'options': ['O(1)', 'O(n)', 'O(n²)', 'O(2ⁿ)'],
          'correctAnswer': 'O(n)',
          'explanation': 'Processing a string of length n takes one transition per character.'
        },
        {
          'questionText': 'Which type of language is always regular?',
          'options': ['Finite languages', 'Infinite languages', 'Palindromes', '{0ⁿ1ⁿ}'],
          'correctAnswer': 'Finite languages',
          'explanation': 'Finite sets can be encoded in a DFA, making them regular.'
        },
        {
          'questionText': 'Is checking if two DFAs accept the same language decidable?',
          'options': ['Undecidable', 'Decidable', 'Semi-decidable', 'Impossible'],
          'correctAnswer': 'Decidable',
          'explanation': 'Minimize both DFAs and compare; regular language equivalence is decidable.'
        },
        {
          'questionText': 'Which statement holds for regular languages?',
          'options': ['Subset of context-free', 'More powerful than context-sensitive', 'Need a stack', 'None of these'],
          'correctAnswer': 'Subset of context-free',
          'explanation': 'Regular languages are a proper subset of context-free languages.'
        },
        {
          'questionText': 'What’s TRUE about regular languages?',
          'options': ['Closed under difference', 'Not DFA-recognizable', 'Not closed under reversal', 'Need a PDA'],
          'correctAnswer': 'Closed under difference',
          'explanation': 'Regular languages are closed under difference (via complement and intersection).'
        },
        {
          'questionText': 'How can you verify if a regular language is empty?',
          'options': ['DFA minimization', 'Checking reachable states', 'Pumping Lemma', 'Building a PDA'],
          'correctAnswer': 'Checking reachable states',
          'explanation': 'If no final state is reachable from the start, the language is empty.'
        },
        {
          'questionText': 'If a DFA has n states, what’s the maximum string length for membership testing?',
          'options': ['n', 'n-1', '2ⁿ', 'No limit'],
          'correctAnswer': 'No limit',
          'explanation': 'DFAs can process strings of any length, limited only by input.'
        },
        {
          'questionText': 'Which is FALSE about regular expressions?',
          'options': ['Cannot express {0ⁿ1ⁿ}', 'Equivalent to finite automata', 'Closed under intersection', 'Can represent infinite languages'],
          'correctAnswer': 'Closed under intersection',
          'explanation': 'Regular expressions aren’t directly closed under intersection; languages are.'
        },
        {
          'questionText': 'Which language class do NFAs and DFAs recognize?',
          'options': ['Regular', 'Context-Free', 'Recursive', 'Recursively Enumerable'],
          'correctAnswer': 'Regular',
          'explanation': 'NFAs and DFAs define the regular language class.'
        }
      ],
      "FLAT_Module 3_Mock Test 1": [
        {
          "questionText": "Which of the following is true for a Context-Free Grammar (CFG)?",
          "options": [
            "Every CFG generates a regular language",
            "Every regular language has a CFG",
            "Every CFG can be recognized by a Pushdown Automaton",
            "Every CFG has a DFA equivalent"
          ],
          "correctAnswer": "Every CFG can be recognized by a Pushdown Automaton",
          "explanation": "A CFG can be recognized by a Pushdown Automaton (PDA)."
        },
        {
          "questionText": "Which of the following productions is NOT in Chomsky Normal Form (CNF)?",
          "options": [
            "A → BC",
            "A → a",
            "A → ε",
            "A → aB"
          ],
          "correctAnswer": "A → aB",
          "explanation": "In Chomsky Normal Form (CNF), productions must be of the form A → BC or A → a, not A → aB."
        },
        {
          "questionText": "Which of the following grammars is NOT context-free?",
          "options": [
            "S → aSb | ε",
            "S → SS | a",
            "S → aSbSc | ε",
            "S → aS | ε"
          ],
          "correctAnswer": "S → aSbSc | ε",
          "explanation": "The grammar S → aSbSc | ε is not context-free as it requires more than one non-terminal to be balanced."
        },
        {
          "questionText": "Which normal form does NOT allow ε-productions (except for the start symbol)?",
          "options": [
            "Chomsky Normal Form (CNF)",
            "Greibach Normal Form (GNF)",
            "Backus-Naur Form (BNF)",
            "None of the above"
          ],
          "correctAnswer": "Chomsky Normal Form (CNF)",
          "explanation": "Chomsky Normal Form (CNF) does not allow ε-productions except for the start symbol."
        },
        {
          "questionText": "Which of the following languages is NOT context-free?",
          "options": [
            "L = { aⁿbⁿ | n ≥ 0 }",
            "L = { wwᴿ | w ∈ {a, b}* }",
            "L = { aⁿbⁿcⁿ | n ≥ 0 }",
            "L = { aⁿb²ⁿ | n ≥ 0 }"
          ],
          "correctAnswer": "L = { aⁿbⁿcⁿ | n ≥ 0 }",
          "explanation": "The language L = { aⁿbⁿcⁿ | n ≥ 0 } is not context-free as it requires counting and balancing three symbols."
        },
        {
          "questionText": "Which of the following statements about context-free languages (CFLs) is TRUE?",
          "options": [
            "CFLs are closed under union",
            "CFLs are closed under intersection",
            "CFLs are closed under complementation",
            "CFLs are closed under difference"
          ],
          "correctAnswer": "CFLs are closed under union",
          "explanation": "Context-free languages (CFLs) are closed under union but not under intersection, complementation, or difference."
        },
        {
          "questionText": "Which of the following is NOT a property of CFGs?",
          "options": [
            "CFGs generate languages recognized by PDAs",
            "CFGs can be ambiguous",
            "CFGs are closed under concatenation",
            "CFGs can be recognized by a DFA"
          ],
          "correctAnswer": "CFGs can be recognized by a DFA",
          "explanation": "CFGs cannot be recognized by a DFA; they require a Pushdown Automaton (PDA)."
        },
        {
          "questionText": "Which of the following is NOT a type of derivation in CFGs?",
          "options": [
            "Leftmost derivation",
            "Rightmost derivation",
            "Bottom-up derivation",
            "Reverse derivation"
          ],
          "correctAnswer": "Reverse derivation",
          "explanation": "Reverse derivation is not a standard type of derivation in CFGs."
        },
        {
          "questionText": "Which data structure is used in a Pushdown Automaton (PDA)?",
          "options": [
            "Queue",
            "Stack",
            "Linked List",
            "Heap"
          ],
          "correctAnswer": "Stack",
          "explanation": "A Pushdown Automaton (PDA) uses a stack to store and manipulate symbols."
        },
        {
          "questionText": "Which class of languages is recognized by a PDA?",
          "options": [
            "Regular",
            "Context-Free",
            "Recursive",
            "Recursively Enumerable"
          ],
          "correctAnswer": "Context-Free",
          "explanation": "A Pushdown Automaton (PDA) recognizes context-free languages."
        },
        {
          "questionText": "A PDA differs from a DFA because:",
          "options": [
            "PDA has more states",
            "PDA can process only finite input",
            "PDA uses a stack",
            "PDA can recognize only regular languages"
          ],
          "correctAnswer": "PDA uses a stack",
          "explanation": "A PDA uses a stack, which allows it to recognize context-free languages, unlike a DFA."
        },
        {
          "questionText": "Which of the following does a PDA NOT contain?",
          "options": [
            "Input Tape",
            "Stack",
            "Transition Function",
            "Tape Head"
          ],
          "correctAnswer": "Tape Head",
          "explanation": "A PDA does not contain a tape head; it uses an input tape and a stack."
        },
        {
          "questionText": "Which of the following languages is accepted by a PDA but NOT by a DFA?",
          "options": [
            "{ aⁿbⁿ | n ≥ 0 }",
            "{ w | w starts with 1 }",
            "{ w | w ends with 101 }",
            "{ w | w has at most 2 b’s }"
          ],
          "correctAnswer": "{ aⁿbⁿ | n ≥ 0 }",
          "explanation": "The language { aⁿbⁿ | n ≥ 0 } is accepted by a PDA but not by a DFA."
        },
        {
          "questionText": "A PDA is said to be deterministic if:",
          "options": [
            "It has at most one transition for each state and input symbol",
            "It can process all regular languages",
            "It has multiple start states",
            "It uses a queue instead of a stack"
          ],
          "correctAnswer": "It has at most one transition for each state and input symbol",
          "explanation": "A PDA is deterministic if it has at most one transition for each state and input symbol."
        },
        {
          "questionText": "Which of the following is TRUE for a nondeterministic PDA (NPDA)?",
          "options": [
            "It can recognize all regular languages",
            "It is equivalent in power to a deterministic PDA",
            "It can recognize more languages than a deterministic PDA",
            "It cannot recognize any language"
          ],
          "correctAnswer": "It can recognize more languages than a deterministic PDA",
          "explanation": "A nondeterministic PDA (NPDA) can recognize more languages than a deterministic PDA."
        }
      ],
      "FLAT_Module 3_Mock Test 2": [
        {
          "questionText": "Which of the following statements about PDA is FALSE?",
          "options": [
            "A PDA can have multiple transitions for the same input",
            "A PDA always halts",
            "A PDA can have an empty stack at the end of computation",
            "A PDA can recognize infinite languages"
          ],
          "correctAnswer": "A PDA always halts",
          "explanation": "A PDA does not always halt; it may enter an infinite loop or fail to accept the input."
        },
        {
          "questionText": "Which of the following is TRUE about a PDA that accepts by final state?",
          "options": [
            "It must have an empty stack",
            "It must be deterministic",
            "It must reach a final state",
            "It must have an infinite stack"
          ],
          "correctAnswer": "It must reach a final state",
          "explanation": "A PDA that accepts by final state must reach a final state to accept the input."
        },
        {
          "questionText": "Which of the following is TRUE about a PDA that accepts by empty stack?",
          "options": [
            "It must always reach a final state",
            "It must reach a state where the stack is empty",
            "It must process an infinite input",
            "It must be a DFA"
          ],
          "correctAnswer": "It must reach a state where the stack is empty",
          "explanation": "A PDA that accepts by empty stack must empty its stack to accept the input."
        },
        {
          "questionText": "Which of the following languages cannot be accepted by a PDA?",
          "options": [
            "{ aⁿbⁿ | n ≥ 0 }",
            "{ aⁿbⁿcⁿ | n ≥ 0 }",
            "{ w | w is a palindrome }",
            "{ w | w contains 'aba' as a substring }"
          ],
          "correctAnswer": "{ aⁿbⁿcⁿ | n ≥ 0 }",
          "explanation": "The language { aⁿbⁿcⁿ | n ≥ 0 } cannot be accepted by a PDA as it requires counting three symbols."
        },
        {
          "questionText": "Which of the following is a true relationship between CFGs and PDAs?",
          "options": [
            "Every PDA has an equivalent CFG",
            "Every CFG has an equivalent DFA",
            "A CFG can recognize more languages than a PDA",
            "A PDA is less powerful than a DFA"
          ],
          "correctAnswer": "Every PDA has an equivalent CFG",
          "explanation": "Every PDA has an equivalent CFG, but not every CFG has an equivalent DFA."
        },
        {
          "questionText": "Which of the following problems is undecidable for context-free languages?",
          "options": [
            "Whether a given PDA accepts a string",
            "Whether two CFGs generate the same language",
            "Whether a CFG is ambiguous",
            "Whether a CFG generates an infinite language"
          ],
          "correctAnswer": "Whether two CFGs generate the same language",
          "explanation": "The equivalence problem for CFGs (whether two CFGs generate the same language) is undecidable."
        },
        {
          "questionText": "Which of the following is a bottom-up parsing technique?",
          "options": [
            "LL(1) Parsing",
            "LR Parsing",
            "Recursive Descent Parsing",
            "Predictive Parsing"
          ],
          "correctAnswer": "LR Parsing",
          "explanation": "LR Parsing is a bottom-up parsing technique."
        },
        {
          "questionText": "Which parsing method is best for handling ambiguous grammars?",
          "options": [
            "LL(1)",
            "LR(1)",
            "Top-Down Parsing",
            "Recursive Descent"
          ],
          "correctAnswer": "LR(1)",
          "explanation": "LR(1) parsing is best for handling ambiguous grammars."
        },
        {
          "questionText": "Which normal form is best for designing efficient parsers?",
          "options": [
            "Chomsky Normal Form",
            "Greibach Normal Form",
            "Backus-Naur Form",
            "None of the above"
          ],
          "correctAnswer": "Chomsky Normal Form",
          "explanation": "Chomsky Normal Form (CNF) is best for designing efficient parsers."
        },
        {
          "questionText": "Which of the following is NOT an application of context-free grammars?",
          "options": [
            "Compilers",
            "Natural language processing",
            "Text searching",
            "XML parsing"
          ],
          "correctAnswer": "Text searching",
          "explanation": "Text searching is not an application of context-free grammars."
        },
        {
          "questionText": "Which of the following does NOT belong to a CFG tuple?",
          "options": [
            "Terminal symbols",
            "Nonterminal symbols",
            "Production rules",
            "Stack"
          ],
          "correctAnswer": "Stack",
          "explanation": "A stack is not part of a CFG tuple; it is used in PDAs."
        },
        {
          "questionText": "A CFG is ambiguous if:",
          "options": [
            "It has more than one start symbol",
            "It produces different parse trees for the same string",
            "It has unit productions",
            "It has epsilon productions"
          ],
          "correctAnswer": "It produces different parse trees for the same string",
          "explanation": "A CFG is ambiguous if it produces multiple parse trees for the same string."
        },
        {
          "questionText": "Which of the following languages can a PDA recognize?",
          "options": [
            "Regular",
            "Context-Free",
            "Context-Sensitive",
            "Recursively Enumerable"
          ],
          "correctAnswer": "Context-Free",
          "explanation": "A PDA can recognize context-free languages."
        },
        {
          "questionText": "Which parsing technique is used for syntax analysis in compilers?",
          "options": [
            "LL(1) Parsing",
            "LR Parsing",
            "Finite State Machine",
            "Bubble Sort"
          ],
          "correctAnswer": "LR Parsing",
          "explanation": "LR Parsing is commonly used for syntax analysis in compilers."
        },
        {
          "questionText": "Which problem is decidable for CFLs?",
          "options": [
            "Membership",
            "Equivalence",
            "Ambiguity",
            "Containment"
          ],
          "correctAnswer": "Membership",
          "explanation": "The membership problem (whether a string belongs to a CFL) is decidable."
        }
      ],
      'FLAT_Module 4_Mock Test 1': [
        {
          'questionText': 'What components make up a Turing Machine?',
          'options': ['Finite set of states', 'Infinite tape', 'Read/write head', 'All of these'],
          'correctAnswer': 'All of these',
          'explanation': 'A TM includes states, an infinite tape, and a head for reading/writing.'
        },
        {
          'questionText': 'Which statement is TRUE about Turing Machines?',
          'options': ['Recognizes only regular languages', 'Recognizes context-free languages', 'Recognizes all recursively enumerable languages', 'Less powerful than a PDA'],
          'correctAnswer': 'Recognizes all recursively enumerable languages',
          'explanation': 'TMs accept all languages a TM can enumerate, beyond regular or context-free.'
        },
        {
          'questionText': 'What tape movements can a Turing Machine perform?',
          'options': ['Left', 'Right', 'Stay in place', 'All of these'],
          'correctAnswer': 'All of these',
          'explanation': 'TMs can move left, right, or stay, offering full tape control.'
        },
        {
          'questionText': 'How does a Turing Machine differ fundamentally from a DFA?',
          'options': ['DFA has a tape', 'TM has a stack', 'TM has an infinite tape', 'DFA recognizes all languages'],
          'correctAnswer': 'TM has an infinite tape',
          'explanation': 'The infinite tape gives TMs memory and power beyond DFA’s finite states.'
        },
        {
          'questionText': 'What can a Turing Machine simulate?',
          'options': ['DFA', 'NFA', 'PDA', 'All of these'],
          'correctAnswer': 'All of these',
          'explanation': 'TMs can emulate any finite automaton or pushdown automaton.'
        },
        {
          'questionText': 'What does a TM’s transition function specify?',
          'options': ['Current state', 'Input symbol', 'Next state, movement, and symbol', 'All of these'],
          'correctAnswer': 'All of these',
          'explanation': 'The function δ: Q × Γ → Q × Γ × {L, R, S} defines TM behavior.'
        },
        {
          'questionText': 'Which variant matches the power of a standard Turing Machine?',
          'options': ['Multi-tape TM', 'DFA', 'PDA', 'Regular Expression'],
          'correctAnswer': 'Multi-tape TM',
          'explanation': 'Multi-tape TMs are equivalent to single-tape TMs via simulation.'
        },
        {
          'questionText': 'How does a non-deterministic TM compare in power to a deterministic TM?',
          'options': ['More powerful', 'Equally powerful', 'Less powerful', 'Cannot be simulated'],
          'correctAnswer': 'Equally powerful',
          'explanation': 'Both recognize the same class (recursively enumerable languages).'
        },
        {
          'questionText': 'Which is NOT a Turing Machine variant?',
          'options': ['Multi-tape TM', 'Non-deterministic TM', 'Quantum TM', 'Finite Automaton'],
          'correctAnswer': 'Finite Automaton',
          'explanation': 'Finite automata are less powerful, not TM variants.'
        },
        {
          'questionText': 'What’s the power of a TM with two read/write heads?',
          'options': ['Less than standard TM', 'More than standard TM', 'Equal to standard TM', 'Cannot be simulated'],
          'correctAnswer': 'Equal to standard TM',
          'explanation': 'Multiple heads can be simulated by a single-tape TM.'
        },
        {
          'questionText': 'When is a problem considered decidable?',
          'options': ['TM halts on all inputs', 'TM may loop infinitely', 'No algorithm exists', 'It’s semi-decidable'],
          'correctAnswer': 'TM halts on all inputs',
          'explanation': 'Decidability requires a TM to always halt with yes/no.'
        },
        {
          'questionText': 'What defines a recursively enumerable language?',
          'options': ['TM accepts it', 'DFA accepts it', 'PDA accepts it', 'TM cannot recognize it'],
          'correctAnswer': 'TM accepts it',
          'explanation': 'A TM that accepts (may not halt on non-members) defines RE languages.'
        },
        {
          'questionText': 'Which language class is NOT closed under complementation?',
          'options': ['Regular', 'Context-Free', 'Recursive', 'Recursively Enumerable'],
          'correctAnswer': 'Recursively Enumerable',
          'explanation': 'RE languages aren’t closed under complement; recursive ones are.'
        },
        {
          'questionText': 'What’s TRUE about recursively enumerable languages?',
          'options': ['Closed under union', 'Closed under complement', 'Closed under intersection', 'Always decidable'],
          'correctAnswer': 'Closed under union',
          'explanation': 'RE languages are closed under union but not complement.'
        },
        {
          'questionText': 'Which problem is decidable?',
          'options': ['DFA string acceptance', 'TM halts on all inputs', 'CFG ambiguity', 'TM equivalence'],
          'correctAnswer': 'DFA string acceptance',
          'explanation': 'DFA membership is decidable in linear time; others are not.'
        }
      ],
      'FLAT_Module 4_Mock Test 2': [
        {
          'questionText': 'Which problem is known to be undecidable?',
          'options': ['Halting Problem', 'DFA Membership', 'CFG Emptiness', 'Regex universality'],
          'correctAnswer': 'Halting Problem',
          'explanation': 'The Halting Problem is famously undecidable; others are decidable.'
        },
        {
          'questionText': 'How does the class of recursive languages relate to recursively enumerable ones?',
          'options': ['Subset', 'Equal', 'Superset', 'None of these'],
          'correctAnswer': 'Subset',
          'explanation': 'Recursive languages (decidable) are a subset of RE (recognizable).'
        },
        {
          'questionText': 'Which problem is semi-decidable?',
          'options': ['Halting Problem', 'DFA Equivalence', 'TM accepts all', 'PDA string acceptance'],
          'correctAnswer': 'Halting Problem',
          'explanation': 'Halting is semi-decidable: TM halts if yes, may loop if no.'
        },
        {
          'questionText': 'Who proved the Halting Problem’s undecidability?',
          'options': ['Alan Turing', 'John von Neumann', 'Kurt Gödel', 'Noam Chomsky'],
          'correctAnswer': 'Alan Turing',
          'explanation': 'Turing’s 1936 proof used a diagonalization argument.'
        },
        {
          'questionText': 'What does the Halting Problem assert?',
          'options': ['TM halts on all', 'No algorithm decides TM halting', 'All languages decidable', 'Recursive languages unrecognizable'],
          'correctAnswer': 'No algorithm decides TM halting',
          'explanation': 'No general TM can predict halting for all inputs.'
        },
        {
          'questionText': 'Which problem is NOT undecidable?',
          'options': ['Halting Problem', 'Post Correspondence', 'TM accepts all', 'DFA string acceptance'],
          'correctAnswer': 'DFA string acceptance',
          'explanation': 'DFA membership is decidable; others are undecidable.'
        },
        {
          'questionText': 'What defines an undecidable problem?',
          'options': ['No TM solves it', 'No algorithm exists', 'Needs infinite memory', 'Solvable by FA'],
          'correctAnswer': 'No TM solves it',
          'explanation': 'Undecidability means no TM halts with an answer for all inputs.'
        },
        {
          'questionText': 'What type of problem is the Post Correspondence Problem?',
          'options': ['Decidable', 'Undecidable', 'Regular', 'Recursive'],
          'correctAnswer': 'Undecidable',
          'explanation': 'PCP’s string matching is proven undecidable via TM simulation.'
        },
        {
          'questionText': 'Which language is NOT recursively enumerable?',
          'options': ['Complement of Halting Problem', 'All binary strings', 'TM descriptions', 'Prime numbers'],
          'correctAnswer': 'Complement of Halting Problem',
          'explanation': 'The complement isn’t RE; others are enumerable by TMs.'
        },
        {
          'questionText': 'Which language class has the greatest power?',
          'options': ['Regular', 'Context-Free', 'Recursive', 'Recursively Enumerable'],
          'correctAnswer': 'Recursively Enumerable',
          'explanation': 'RE includes all TM-recognizable languages, beyond recursive.'
        },
        {
          'questionText': 'Which is NOT a property of recursively enumerable languages?',
          'options': ['Union closure', 'Intersection closure', 'Complement closure', 'TM recognizable'],
          'correctAnswer': 'Complement closure',
          'explanation': 'RE languages aren’t closed under complement.'
        },
        {
          'questionText': 'What’s TRUE about an undecidable problem?',
          'options': ['Semi-decidable solution', 'No algorithmic solution', 'Solvable by DFA', 'Always context-free'],
          'correctAnswer': 'No algorithmic solution',
          'explanation': 'Undecidable problems lack a general halting algorithm.'
        },
        {
          'questionText': 'What does an infinite loop in a TM imply?',
          'options': ['Language undecidable', 'Language recursive', 'Machine halts', 'Language regular'],
          'correctAnswer': 'Language undecidable',
          'explanation': 'Infinite loops often signal undecidability (e.g., Halting Problem).'
        },
        {
          'questionText': 'Which problem class is recognizable but not always decidable?',
          'options': ['Recursively Enumerable', 'Regular', 'Context-Free', 'Recursive'],
          'correctAnswer': 'Recursively Enumerable',
          'explanation': 'RE languages are accepted by TMs, but not all are decidable.'
        },
        {
          'questionText': 'What does the Church-Turing Thesis propose?',
          'options': ['All computable by TM', 'Every function decidable', 'Regular equals recursive', 'No undecidable problems'],
          'correctAnswer': 'All computable by TM',
          'explanation': 'It asserts TMs capture all effectively computable functions.'
        }
      ],
      'FLAT_Module 5_Mock Test 1': [
        {
          'questionText': 'Which class in the Chomsky hierarchy is the most restrictive?',
          'options': ['Recursively Enumerable', 'Recursive', 'Context-Free', 'Regular'],
          'correctAnswer': 'Regular',
          'explanation': 'Regular languages (Type-3) are the simplest, recognized by finite automata.'
        },
        {
          'questionText': 'Which language class requires a Turing Machine for recognition?',
          'options': ['Regular', 'Context-Free', 'Context-Sensitive', 'Recursively Enumerable'],
          'correctAnswer': 'Recursively Enumerable',
          'explanation': 'RE languages need unrestricted TMs, beyond simpler automata.'
        },
        {
          'questionText': 'What’s a TRUE statement about the Chomsky hierarchy?',
          'options': ['Regular ⊆ Context-Free', 'Context-Sensitive excludes Context-Free', 'Recursive includes all Context-Free', 'All RE are regular'],
          'correctAnswer': 'Regular ⊆ Context-Free',
          'explanation': 'Regular languages are a proper subset of context-free languages.'
        },
        {
          'questionText': 'Which grammar type generates context-sensitive languages?',
          'options': ['Type 0', 'Type 1', 'Type 2', 'Type 3'],
          'correctAnswer': 'Type 1',
          'explanation': 'Type-1 grammars (context-sensitive) allow context-dependent rules.'
        },
        {
          'questionText': 'What’s NOT true about context-sensitive languages?',
          'options': ['Accepted by LBA', 'Closed under intersection', 'Closed under union', 'Recognized by PDA'],
          'correctAnswer': 'Recognized by PDA',
          'explanation': 'PDAs handle context-free, not context-sensitive languages; LBAs are needed.'
        },
        {
          'questionText': 'Which Chomsky hierarchy class is the most powerful?',
          'options': ['Regular', 'Context-Free', 'Context-Sensitive', 'Recursively Enumerable'],
          'correctAnswer': 'Recursively Enumerable',
          'explanation': 'RE (Type-0) includes all TM-recognizable languages.'
        },
        {
          'questionText': 'Which language might NOT be recursive?',
          'options': ['L1 ∪ L2 (recursive)', 'L1 ∩ L2 (recursive)', 'Complement of RE', 'TM always halts'],
          'correctAnswer': 'Complement of RE',
          'explanation': 'RE complement isn’t always RE or recursive; others are decidable.'
        },
        {
          'questionText': 'Which is NOT a property of recursive languages?',
          'options': ['Closed under union', 'Closed under intersection', 'Closed under complement', 'Undecidable'],
          'correctAnswer': 'Undecidable',
          'explanation': 'Recursive languages are decidable; undecidability applies to some RE.'
        },
        {
          'questionText': 'Which languages can a TM recognize but not always decide?',
          'options': ['Regular', 'Context-Free', 'Recursive', 'Recursively Enumerable'],
          'correctAnswer': 'Recursively Enumerable',
          'explanation': 'RE languages are TM-recognizable, but not all are decidable.'
        },
        {
          'questionText': 'Which language class is closed under complement?',
          'options': ['Recursive', 'Recursively Enumerable', 'Context-Free', 'None of these'],
          'correctAnswer': 'Recursive',
          'explanation': 'Recursive languages are decidable, hence closed under complement.'
        },
        {
          'questionText': 'What’s TRUE about recursively enumerable languages?',
          'options': ['Closed under intersection', 'Closed under complement', 'Subset of recursive', 'Closed under difference'],
          'correctAnswer': 'Closed under intersection',
          'explanation': 'RE languages are closed under intersection and union, not complement.'
        },
        {
          'questionText': 'Which is an example of a recursive language?',
          'options': ['Valid arithmetic expressions', 'Halting Problem', 'Post Correspondence', 'Infinite palindromes'],
          'correctAnswer': 'Valid arithmetic expressions',
          'explanation': 'This is decidable; others are undecidable or infinite in scope.'
        },
        {
          'questionText': 'Which language class is NOT closed under intersection?',
          'options': ['Regular', 'Context-Free', 'Context-Sensitive', 'Recursive'],
          'correctAnswer': 'Context-Free',
          'explanation': 'Context-Free languages aren’t closed under intersection (e.g., {aⁿbⁿcⁿ}).'
        },
        {
          'questionText': 'What’s TRUE about context-sensitive languages?',
          'options': ['Closed under complement', 'Closed under union, not intersection', 'Recognized by PDA', 'Not in Chomsky hierarchy'],
          'correctAnswer': 'Closed under complement',
          'explanation': 'Context-sensitive languages are closed under complement via LBAs.'
        },
        {
          'questionText': 'Which holds for recursively enumerable languages?',
          'options': ['Closed under union', 'Closed under complement', 'Closed under intersection, not union', 'Equal to context-free'],
          'correctAnswer': 'Closed under union',
          'explanation': 'RE languages are closed under union and intersection, not complement.'
        }
      ],
      'FLAT_Module 5_Mock Test 2': [
        {
          'questionText': 'Which operation might make a recursive language non-recursive?',
          'options': ['Intersection', 'Union', 'Complement', 'None of these'],
          'correctAnswer': 'None of these',
          'explanation': 'Recursive languages are closed under intersection, union, and complement.'
        },
        {
          'questionText': 'Which language class isn’t always closed under complementation?',
          'options': ['Regular', 'Context-Free', 'Recursive', 'Context-Sensitive'],
          'correctAnswer': 'Context-Free',
          'explanation': 'Context-Free languages aren’t closed under complement (e.g., {aⁿbⁿcⁿ} complement).'
        },
        {
          'questionText': 'What’s TRUE for context-sensitive languages?',
          'options': ['Accepted by TM with bounded memory', 'More powerful than RE', 'Equal to recursive', 'Recognized by PDA'],
          'correctAnswer': 'Accepted by TM with bounded memory',
          'explanation': 'LBAs (bounded TMs) recognize context-sensitive languages.'
        },
        {
          'questionText': 'What’s the status of the Post Correspondence Problem?',
          'options': ['Decidable', 'Undecidable', 'Regular', 'Context-Free'],
          'correctAnswer': 'Undecidable',
          'explanation': 'PCP is a classic undecidable problem reducible to the Halting Problem.'
        },
        {
          'questionText': 'Which is an undecidable problem?',
          'options': ['DFA string acceptance', 'CFG ambiguity', 'Halting Problem', 'Regex equivalence'],
          'correctAnswer': 'Halting Problem',
          'explanation': 'Halting Problem is undecidable; others are decidable except CFG ambiguity.'
        },
        {
          'questionText': 'Which problem is NOT recursively enumerable?',
          'options': ['Halting Problem Complement', 'Post Correspondence', 'TM Membership', 'Unrestricted TM problem'],
          'correctAnswer': 'Halting Problem Complement',
          'explanation': 'The complement isn’t RE; others are TM-recognizable.'
        },
        {
          'questionText': 'What’s TRUE about recursive languages?',
          'options': ['Subset of RE', 'Include all RE', 'Equal to Context-Free', 'Recognized by PDA'],
          'correctAnswer': 'Subset of RE',
          'explanation': 'Recursive languages are decidable, a proper subset of RE.'
        },
        {
          'questionText': 'Which class is strictly more powerful than context-free?',
          'options': ['Regular', 'Context-Sensitive', 'Recursive', 'Recursively Enumerable'],
          'correctAnswer': 'Context-Sensitive',
          'explanation': 'Context-Sensitive (Type-1) exceeds Context-Free (Type-2) in power.'
        },
        {
          'questionText': 'Which is NOT a context-sensitive language?',
          'options': ['{aⁿbⁿcⁿ | n ≥ 0}', '{ww | w ∈ {a, b}*}', '{x | x is arithmetic}', '{w | more a’s than b’s}'],
          'correctAnswer': '{ww | w ∈ {a, b}*}',
          'explanation': 'This is context-free but not context-sensitive; others fit Type-1.'
        },
        {
          'questionText': 'What’s NOT true for recursive languages?',
          'options': ['Closed under union', 'Closed under intersection', 'Closed under complement', 'Undecidable'],
          'correctAnswer': 'Undecidable',
          'explanation': 'Recursive languages are decidable by definition.'
        },
        {
          'questionText': 'Which statement about the Chomsky hierarchy is FALSE?',
          'options': ['Type-0 is unrestricted', 'Type-1 is context-sensitive', 'Type-2 is regular', 'Type-3 is regular'],
          'correctAnswer': 'Type-2 is regular',
          'explanation': 'Type-2 is context-free; Type-3 is regular.'
        },
        {
          'questionText': 'Which languages can a TM decide?',
          'options': ['Recursive', 'Context-Free', 'Context-Sensitive', 'None of these'],
          'correctAnswer': 'Recursive',
          'explanation': 'Recursive languages are decidable; others may only be recognizable.'
        },
        {
          'questionText': 'Which class is recognized by a Linear Bounded Automaton?',
          'options': ['Context-Free', 'Context-Sensitive', 'Regular', 'Recursively Enumerable'],
          'correctAnswer': 'Context-Sensitive',
          'explanation': 'LBAs define context-sensitive languages (Type-1).'
        },
        {
          'questionText': 'Which problem is semi-decidable?',
          'options': ['Halting Problem', 'DFA Equivalence', 'CFG Emptiness', 'Regular Inclusion'],
          'correctAnswer': 'Halting Problem',
          'explanation': 'Halting is semi-decidable: TM halts if yes, may loop if no.'
        },
        {
          'questionText': 'Which language class is the most general?',
          'options': ['Regular', 'Context-Free', 'Context-Sensitive', 'Recursively Enumerable'],
          'correctAnswer': 'Recursively Enumerable',
          'explanation': 'RE encompasses all TM-recognizable languages, the broadest class.'
        }
      ],
      "COA_All Modules_Mock Test 1": [
        {
          "questionText": "What is the role of the ALU in a CPU?",
          "options": [
            "Memory storage",
            "Arithmetic and logic operations",
            "Instruction fetching",
            "Input/output management"
          ],
          "correctAnswer": "Arithmetic and logic operations",
          "explanation": "The ALU (Arithmetic Logic Unit) performs arithmetic and logical operations in the CPU."
        },
        {
          "questionText": "Which memory is fastest in a computer system?",
          "options": ["RAM", "Cache", "Hard Disk", "ROM"],
          "correctAnswer": "Cache",
          "explanation": "Cache memory is the fastest, located closest to the CPU for quick data access."
        },
        {
          "questionText": "What does pipelining improve in a processor?",
          "options": [
            "Power consumption",
            "Instruction throughput",
            "Memory size",
            "Clock speed"
          ],
          "correctAnswer": "Instruction throughput",
          "explanation": "Pipelining increases the number of instructions processed per unit time."
        },
      ],
    };

    // Construct the key based on subject, module, and mock test number
    final key = '${widget.subject}_${widget.module}_${widget.mockTestNumber ?? "Mock Test 1"}';

    // Fetch questions based on the key
    _allQuestions = questionBank[key] ?? [];

    setState(() {
      _isLoading = false;
    });
  }

  void _selectAnswer(int questionIndex, String answer) {
    if (_testSubmitted) return;

    setState(() {
      _selectedAnswers[questionIndex] = answer;
    });
  }

  void _submitTest() {
    if (_testSubmitted) return;

    _timer.cancel();

    int correct = 0;

    for (var i = 0; i < _selectedQuestions.length; i++) {
      if (_selectedAnswers[i] == _selectedQuestions[i]['correctAnswer']) {
        correct++;
      }
    }

    setState(() {
      _correctAnswers = correct;
      _testSubmitted = true;
    });

    // Calculate percentage
    double percentage = (_correctAnswers / _selectedQuestions.length * 100);

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
                const Color(0xFFB2F2BB).withOpacity(0.5), // lightGreen from your original code
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1F7A4D).withOpacity(0.2), // darkGreen from your original code
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
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F7A4D), // darkGreen
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
                      'Score: $_correctAnswers / ${_selectedQuestions.length}',
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
                  backgroundColor: const Color(0xFF33b864), // primaryGreen
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
  void dispose() {
    Provider.of<CurrentPageProvider>(context, listen: false).setCurrentPage('home');
    if (_testStarted) {
      _timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Define the green color scheme from year3.dart
    final Color primaryGreen = const Color(0xFF33b864); // Main green
    final Color lightGreen = const Color(0xFFB2F2BB); // Lighter green
    final Color darkGreen = const Color(0xFF1F7A4D); // Darker green

    // Get the status bar height using MediaQuery
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    // Set the status bar color to dark green
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: darkGreen, // Set status bar color to dark green
        statusBarIconBrightness: Brightness.light, // Light icons for dark background
      ),
    );

    return Scaffold(
      // Remove the AppBar
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              lightGreen.withOpacity(0.4), // Updated to light green
              Colors.white,
            ],
          ),
        ),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _allQuestions.isEmpty
            ? _buildNoQuestionsView()
            : !_testStarted
            ? _buildStartTestView()
            : Column(
          children: [
            // Add padding for the status bar
            SizedBox(height: statusBarHeight),
            // Time and Answered Questions Container
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 16,
              ),
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
                      color: Colors.white, // White text for contrast
                    ),
                  ),
                  Text(
                    'Answered: ${_selectedAnswers.length}/${_selectedQuestions.length}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // White text for contrast
                    ),
                  ),
                ],
              ),
            ),
            // Questions List
            Expanded(
              child: _buildQuestionsListView(),
            ),
          ],
        ),
      ),
      // Bottom Navigation Bar (Submit Button)
      bottomNavigationBar: _allQuestions.isNotEmpty && _testStarted
          ? BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ElevatedButton(
            onPressed: _testSubmitted ? null : _submitTest,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryGreen, // Use primary green
              foregroundColor: Colors.white, // White text
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
            '${widget.subject} - ${widget.module}',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Mock Test ${widget.mockTestNumber ?? "1"}',
            style: const TextStyle(
              fontSize: 18,
            ),
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
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildInfoRow('Questions', '${_allQuestions.length} questions'),
                _buildInfoRow('Duration', '30 minutes'),
                _buildInfoRow('Question Type', 'Multiple Choice'),
              ],
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _startTest,
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.subjectColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            child: const Text('Start Exam'),
          ),
          const SizedBox(height: 16),
          Text(
            'Note: The timer will start once you begin the exam',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontStyle: FontStyle.italic,
            ),
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
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
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
            'Questions for ${widget.module} have not been added yet.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _loadQuestions,
            child: const Text('Refresh'),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionsListView() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _selectedQuestions.length,
      itemBuilder: (context, index) {
        final question = _selectedQuestions[index];
        final displayNumber = question['displayNumber'];
        final options = question['options'] as List<String>;
        final selectedAnswer = _selectedAnswers[index];
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
                        ? (isCorrect
                        ? Colors.green.withOpacity(0.1)
                        : Colors.red.withOpacity(0.1))
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
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Explanation: ${question['explanation']}',
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
                    ),
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