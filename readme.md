HW02
===
This is the hw02 sample. Please follow the steps below.

# Build the Sample Program

1. Fork this repo to your own github account.

2. Clone the repo that you just forked.

3. Under the hw02 dir, use:

	* `make` to build.

	* `make clean` to clean the ouput files.

4. Extract `gnu-mcu-eclipse-qemu.zip` into hw02 dir. Under the path of hw02, start emulation with `make qemu`.

	See [Lecture 02 ─ Emulation with QEMU] for more details.

5. The sample is designed to help you to distinguish the main difference between the `b` and the `bl` instructions.  

	See [ESEmbedded_HW02_Example] for knowing how to do the observation and how to use markdown for taking notes.

# Build Your Own Program

1. Edit main.s.

2. Make and run like the steps above.

# HW02 Requirements

1. Please modify main.s to observe the `push` and the `pop` instructions:  

	Does the order of the registers in the `push` and the `pop` instructions affect the excution results?  

	For example, will `push {r0, r1, r2}` and `push {r2, r0, r1}` act in the same way?  

	Which register will be pushed into the stack first?

2. You have to state how you designed the observation (code), and how you performed it.  

	Just like how [ESEmbedded_HW02_Example] did.

3. If there are any official data that define the rules, you can also use them as references.

4. Push your repo to your github. (Use .gitignore to exclude the output files like object files or executable files and the qemu bin folder)

[Lecture 02 ─ Emulation with QEMU]: http://www.nc.es.ncku.edu.tw/course/embedded/02/#Emulation-with-QEMU
[ESEmbedded_HW02_Example]: https://github.com/vwxyzjimmy/ESEmbedded_HW02_Example

--------------------

 [x] **If you volunteer to give the presentation next week, check this.**

--------------------

HW02 
===
## 1. 實驗題目
改寫程式以比較push指令中暫存器順序造成的影響。
## 2. 實驗步驟
1. 先將資料夾 gnu-mcu-eclipse-qemu 完整複製到 ESEmbedded_HW02 資料夾中

2. 設計測試程式 main.s ，從 _start 開始後依序執行(a)照順序進行push進stack，並使用pop一次全部取回暫存器(b)照順序進行push進stack，並使用pop逐一取回暫存器(c)相反戰存器順序進行push進stack，並使用pop以相反的順序一次全部取回暫存器。


main.s:

```assembly
_start:
    mov    r0,#001
    mov    r1,#002
    mov    r2,#003
    
    push   {r0,r1,r2} //pushing forward
    pop    {r3,r4,r5} //poping forward

    mov    r3,0
    mov    r4,0
    mov    r5,0

    push   {r0,r1,r2}
    pop    {r3}       //testing pop 
    pop    {r4}
    pop    {r5}

    push   {r2,r1,r0} //pushing backward
    pop    {r5,r4,r3} //poping backward

	//
	//branch w/o link
	//
	b	label01

label01:
	nop

	//
	//branch w/ link
	//
	bl	sleep

sleep:
	nop
	b	.	.
```

4. 將 main.s 編譯，此時assembler會出現下圖之warring，顯示反向進行push與pop的順序沒有照著遞增順序。  
![](https://github.com/Kai0522/ESEmbedded_HW02/blob/master/img/warning.png)  
接著取得其反組譯碼如下：  
![](https://github.com/Kai0522/ESEmbedded_HW02/blob/master/img/disassembly.png)  
此時可以看到原先反向push與pop的指令接被assembler自動轉換為遞增順序，由此可以確定使用push與pop指令並無法顛倒順序反向送入與取出stack。  
5.以下再進行push順序的比較，如果照著順向的順序送入stack時，結果將會是由右至左的順序將暫存器由上至下的堆入堆疊記憶體。  
![](https://github.com/Kai0522/ESEmbedded_HW02/blob/master/img/pushing_stack.png)
![](https://github.com/Kai0522/ESEmbedded_HW02/blob/master/img/stack.png)  
6.再將資料一次進行pop可以看到，push的資料順序與pop的順序具有對應的關聯性，順序會相同。  
![](https://github.com/Kai0522/ESEmbedded_HW02/blob/master/img/poping_stack.png)
7.最後將資料重新照順序push上stack，再逐一使用pop指令將資料取下，如下圖，可以看到最後被push的資料會最先被pop出暫存器，所以與上圖比較一次pop多個暫存器時順序為由左至右。
![](https://github.com/Kai0522/ESEmbedded_HW02/blob/master/img/poping_one.png)
## 3. 結果與討論
1.無法將暫存器以反向順序送入stack，Assembler會自動調整順序，並由右至左進行push。  
2.堆疊記憶體的特性為從上而下儲存且具有先進後出的特性，最後被push進堆疊的資料會最先被pop取出 。
