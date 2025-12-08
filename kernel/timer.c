#include "defs.h"

// 声明外部测试标志
extern volatile int *interrupt_test_flag;

void timeintr(void){
    debug("timer interrupt\n");
    if (interrupt_test_flag){
        (*interrupt_test_flag)++;
    }
    
    struct proc *p = myproc();
    if(p == 0){
        return;
    }
    
    if(p->state != RUNNING){
        return;
    }
    
    // 减少时间片
    p->time_slice--;
    
    debug("[TIMER] PID %d time_slice: %d, priority: %d\n", 
          p->pid, p->time_slice, p->priority);
    
    // 时间片用完，执行降级和调度
    if(p->time_slice <= 0){
        // 降级处理：将优先级降低一级
        if (p->priority < LOW_PRIO) {
            p->priority++;
            
            // 更新对应的时间片基数
            switch(p->priority) {
                case HIGH_PRIO:
                    p->base_time_slice = HIGH_PRIO_SLICE;
                    break;
                case MID_PRIO:
                    p->base_time_slice = MID_PRIO_SLICE;
                    break;
                case LOW_PRIO:
                    p->base_time_slice = LOW_PRIO_SLICE;
                    break;
            }
            
            debug("[TIMER] PID %d 时间片耗尽，降级到优先级 %d\n", 
                  p->pid, p->priority);
        } else {
            debug("[TIMER] PID %d 时间片耗尽，已在最低优先级\n", p->pid);
        }
        
        // 触发调度，让出CPU
        yield();
    }
}