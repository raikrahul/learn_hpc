```cpp
#include <stdio.h> // stdio.h (1) - BOF risk via printf! I/O bottleneck!
                 // L1-API: C std I/O. printf, scanf. BOF vulns in format strings.
                 // L2-Algo: Formatted I/O slow HPC. Perf implosion if algo I/O heavy.
                 // L3-System: Syscalls for I/O. Kernel I/O bottleneck.
                 // L4-Edge: Format string bugs = code exec risk! Parallel printf DoS.
                 // L5-Kernel: Kernel I/O lock contention if stdio heavy. Starvation.
                 // CTO Rec: Ban printf. Binary I/O, high-perf logs. Audit fmt bugs.

#include <omp.h> // omp.h (2) - OpenMP Races! Thread Safety woes!
                 // L1-API: OpenMP header. #pragma parallel - Race incubator.
                 // L2-Algo: Parallel algos NEED sync. Algo bugs -> Race, Deadlock.
                 // L3-System: OS threads. Thread oversub, Starvation risk, perf.
                 // L4-Edge: Bad data sharing=Race. Collapse misuse=bad parallel.
                 // L5-Compiler: Compiler OpenMP bugs -> subtle Races. Opts expose Races.
                 // CTO Rec: OpenMP training. Code reviews for Thread Safety. Static
                 //         analysis. Profilers, race detectors in CI tests. Lock-free.

/*
  int main(int argc, char* argv[])

  The main program is the starting point for an OpenMP program.
  This one simply reports its own thread number.

  Inputs: none

  Outputs: Prints "Hello World #" where # is thread number.
*/
int sum = 0;
int main(int argc, char* argv[])
{

  // OpenMP does parallelism through the use of threads.
  // #pragma are compiler directives that are handled by OpenMP
  // The directive applies to the next simple or compound statement
  // By default, threads created match computer cores.
#pragma omp parallel // Parallel region (3) - Race Condition if shared vars unsafe!
                 // L3-HPC: OpenMP parallel. Race Condition risk shared vars unsafe.
                 // L4-Edge: Global 'sum' mod in region -> classic Race. Corrupt sum.
                 // CTO Rec: Mandate race detection (ThreadSanitizer, Helgrind).
                 //         Race checks MUST be default compilation. CI tests++.

  // Simple statement in parallel threads.
  printf("Hello World! I am thread %d out of %d\n",
	 omp_get_thread_num(), omp_get_num_threads()); // Thread info print (4) - Parallel I/O bottleneck, I/O lock contention.
                 // L2-Algo: Parallel printf BAD in HPC. Serialization to stdout.
                 // L3-System: OS syscalls for printf. Kernel I/O sched bottleneck.
                 // L4-Edge: High thread count + printf flood = I/O overwhelm DoS.
                 // L5-Kernel: stdio lock contention in kernel. Kernel Starvation.
                 // CTO Rec: No printf in parallel loops. Batch log output userspace.

  printf("All done with the parallel code.\n"); // Serial print after parallel (5) - Serial bottleneck if parallel short.
                 // L2-Algo: Serial section after parallel - Amdahl's Law limit.
                 // L4-Edge: Short parallel->"hello world", serial printf overhead>>work.
                 //         Thread Oversubscription if threads >> tiny work unit.
                 // CTO Rec: Profile overhead vs gain. Serial may be faster for tiny.

#pragma omp parallel for reduction(+:sum) // Parallel for + reduction (6) - Reduction overhead, but Race-free sum.
// reduction(+:sum)                      // reduction clause (7) - Reduction impl perf matters! Contention?
for ( int i =0; i < 1000; i++) // Serial loop index i (8) - 'i' usually private, no Race.
{                                     // L4: N=1000, parallel overhead might > loop body work. Bench.

  sum +=i; // Accumulate sum (9) - Reduction(+) for thread-safe 'sum'. Compiler reduction quality key!
         // L3-HPC: Reduction (+) - Compiler/runtime thread-safe sum.
         // L3-HPC: Reduction quality key. Atomics? Critical? Perf HUGE var.
         // L4-Edge: Reduction overhead increases with thread count. Scaling cost?
         // L5-Compiler: Compiler/runtime impl handles reduction. No kernel '+'.
         // CTO Rec: Verify reduction impl perf on target compiler/runtime.

} // End parallel for (10) - Barrier sync - Load Imbalance = Starvation!
  // L3-HPC: Barrier at OpenMP for end. Sync point. Load Imbalance=Starvation.
  // L4-Edge: Uneven loop iter times -> Barrier wait DOMINATES runtime.
  // L5-Kernel: Kernel thread join/sync, OS sync for barrier. Overhead.
  // CTO Rec: Workload analysis in loops. Dynamic schedule #pragma omp for.
  //         Profile loop iter times. Tune schedule clause.

printf("%d\n", sum); // Print final sum (11) - Serial output - no HPC bugs here now.
                 // L2-Algo: Serial printf output for result. End of test code.
  return 0; // Exit main (12) - Clean exit. No HPC bug relevance on exit.
}
```

```cpp
#include <stdio.h> // stdio.h (1) - BOF via printf, HPC I/O bottleneck.
#include <omp.h> // omp.h (2) - OpenMP Races, Thread Safety, Collapse?

/*
  This program demonstrates OpenMP sections.
  Sections divide code block into parallel parts.
  Each section can run by different threads.

  Inputs: None

  Outputs: Prints messages from parallel sections.
*/

void task_a() {
  printf("Task A is being executed by thread %d\n", omp_get_thread_num());
  // task_a (2) - printf - I/O in parallel task - serialization?
  //         Thread Safety? If SHARED resources outside printf! Review it!
  // L2-Algo: printf workload trivial. Perf bottleneck if tasks complex, I/O.
  // L3-System: Parallel printf syscalls. I/O lock contention likely.
  // L4-Edge: Task_a assumed thread-safe NOW, but what if complex later?
  // CTO Rec: Tasks (a,b,c) NEED Thread Safety audit - if access SHARED data.
}

void task_b() {
  printf("Task B is being executed by thread %d\n", omp_get_thread_num());
  // task_b (3) - printf in parallel task, Thread Safety like task_a?
  // CTO Rec: Parallel sections for DECOMPOSED compute tasks, NOT I/O.
  //         Re-design logging if I/O is parallel bottleneck in sections.
  // Similar to task_a, but for Task B.
}

void task_c() {
  printf("Task C is being executed by thread %d\n", omp_get_thread_num());
  // task_c (4) - printf. Thread Safety like task_a & b? Audit!
  // CTO Rec: Document data sharing & sync in EACH section, Thread Safety MUST be in design.
  // Similar to task_a and task_b, but for Task C.
}

int main() {
  printf("Starting parallel sections example.\n");
  // Initial printf (5) - Serial start msg. No HPC bugs at serial start.

  #pragma omp parallel sections // Parallel sections begin (6) - Thread Safety risk if tasks share data bad.
  // L1-API: OpenMP parallel sections. Concurrent sections IF threads, no dep.
  // L2-Algo: Sections BEST for INDEPENDENT work units. SHARED MUTABLE data?
  //         -> Race Condition LIKELY if no sync!
  // L3-HPC: OpenMP threads non-deterministic section exec order = Race hell!
  // L4-Edge: INSUFFICIENT THREADS for all sections -> Thread Reuse non-det!
  // CTO Rec: Enforce task independence in sections OR explicit sync inside.
  //         DOCUMENT data sharing & sync in parallel sections region design.

  // OpenMP directive for parallel sections region. Code in {} sections.
  // OpenMP tries to run sections in parallel with available threads.
  {
    #pragma omp section // Section 1 (7) - task_a - Thread-safe ASSUMPTION so far. What if it gets complex??
    // Section pragma in 'parallel sections'. Task_a() code in this section.
    {
      task_a(); // Execute task_a (8) - Race in task_a if shared data & unsafe access.
    } // Section 1 end

    #pragma omp section // Section 2 (9) - task_b - Thread Safety audit task_b NOW too!
    {
      task_b(); // Execute task_b (10) - Race Condition in task_b. Review task body code!
    } // Section 2 end

    #pragma omp section // Section 3 (11) - task_c - Thread Safety in task_c body? Check ALL!
    {
      task_c(); // Execute task_c (12) - Race Condition in task_c - all tasks audit req.
    } // Section 3 end
  } // Parallel sections region end (13) - Implicit Barrier - Load Imbalance issue point.
  // L3-HPC: Implicit Barrier at #pragma omp sections end. Threads sync here.
  // L3-HPC: Barrier -> Load Imbalance in tasks = idle wait time at barrier.
  // L4-Edge: Non-uniform task times -> barrier wait dominates parallel runtime.
  // CTO Rec: Analyze task time variance. Load balance techniques if needed.
  //         Dynamic sched in sections? Task-based parallelism may be better.

  printf("Finished parallel sections example.\n");
  // Final printf (14) - Serial end message. No HPC bug issues here.
  return 0; // Exit main (15) - Clean exit. No HPC bugs for program exit.
}
```
