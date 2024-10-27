#include <linux/module.h>
#include <linux/sched.h>
#include <linux/init.h>

int my_init_module(void)
{
    printk("hello from your kernel module lab\n");
    return 0;
}

void my_cleanup_module(void)
{
    printk("goodbye from your kernel module lab\n");
    // return 0;
}

module_exit(my_cleanup_module);
module_init(my_init_module);
MODULE_LICENSE("GPL");