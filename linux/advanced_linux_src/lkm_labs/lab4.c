#include <linux/module.h>
#include <linux/sched.h>
// #include <linux/init.h>

MODULE_AUTHOR("Jun Luo");
MODULE_DESCRIPTION("A very simple loadable module that does almost nothing.");

static int number = 24601;
static char* word = "icecream";

module_param(number, int, S_IRUGO);
MODULE_PARM_DESC(number, "A sample integer modifiable parameter");
module_param(word, charp, S_IRUGO);
MODULE_PARM_DESC(word, "A sample string modifiable parameter");

int my_init_module(void)
{
    printk("hello from your kernel module lab4\n");
    printk("kernel module lab4: number=%d, word=%s\n", number, word);
    return 0;
}

void my_cleanup_module(void)
{
    printk("goodbye from your kernel module lab4\n");

}

module_exit(my_cleanup_module);
module_init(my_init_module);
MODULE_LICENSE("GPL");