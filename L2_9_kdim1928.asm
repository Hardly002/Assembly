; Compile:
; nasm -f win32 L2_9_kdim1928.asm
; nlink L2_9_kdim1928.obj -lmio -lio -o asd.exe

%include 'mio.inc'
%include 'io.inc'

global main



				
			
section .text
main:


    mov     al, '!'
    call    mio_writechar
    

    mov     al, 13              
    call    mio_writechar
    mov     al, 10              
    call    mio_writechar
    
    mov     eax, message
    call    mio_writestr
    call    mio_writeln         
    
	call 	readec
	
	call 	Writedecvec
	
	call 	isneg
	
	mov 	eax,[minusz]
	call 	mio_writechar
	
	mov 	eax,49
	mov 	[minusz],eax
	call 	Felepit
	
	call 	Convertohex
	
	
	
	
	
readec:
	mov 	ecx,x
	.nextchar:
		; read a character from the keyboard
		call    mio_readchar
		; end if ENTER was pressed
		cmp     al, 13
		je      .end
		; display the character on the screen!
		call    mio_writechar
		mov 	[ecx],eax
		add 	ecx,1
		; erase the previous character if BACKSPACE was pressed
		cmp     al, 8
		jne     .nextchar
		mov     al, ' '
		call    mio_writechar
		mov     al, 8
		call    mio_writechar
		sub 	ecx,1
		; next iteration
		jmp     .nextchar
	
	.end:
		mov 	[meretx],ecx
		ret


Writedecvec:
	call 	mio_writeln
	mov 	ecx,x
	.ciklus:	
		mov 	eax,[ecx]
		call 	mio_writechar
		add 	ecx,1
		cmp 	ecx,[meretx]
		ja 		.asd
		jmp 	.ciklus
	
	.asd:
		ret










isneg:
	mov 	ecx,x
	mov 	eax,[ecx]
	cmp 	eax,'-'
	je		.neg
	jne    .poz
.neg:
		mov 	edx,49
		mov 	[minusz],edx
		ret
.poz:
	mov 	edx,48
	mov 	[minusz],edx
	ret



















Felepit:
	mov 	ecx,x
	mov 	eax,[minusz]
	cmp 	eax,48
	je 		.felepit
	jne 	.elo
	.elo:
		add 	ecx,1
		jmp 	.felepit
	.felepit:
		mov 	eax,[ecx]
		sub 	al,48     
		and 	eax,0x0000000F   
		push 	eax         
		mov 	edx, 0
		mov 	eax,[decim]
		mov 	ebx,10
		mul 	ebx          
		pop 	ebx          
		add 	ebx,eax
		mov 	[decim],ebx
		add 	ecx,1
		cmp 	ecx,[meretx]
		je 		.asg
		jmp 	.felepit
.asg:
	call 	mio_writeln
	mov 	eax,[decim]
	call 	io_writeint
	call 	mio_writeln
	ret
	


Convertohex:
	mov 	ebx,16
	mov 	edx,0 ;sorszam
	mov 	ecx,0 ;sorszam
	.convertohex:
		mov 	eax,[decim]
		mov 	edx,0
		div 	ebx
		mov 	[decim],eax
		push 	edx
		add 	ecx,1
		cmp 	eax,0
		je 		.asf
		jmp 	.convertohex


	.asf:
		mov 	edx,0 		;edx et nullazom az ecx marad
		jmp 	.writehex
		
		
	.writehex:
		pop 	eax
		cmp 	eax,10
		jb 		.tizalatt
		jge		.tizfelett
	.tizalatt:
		add		eax,48
		mov 	[finalstring+edx],eax
		add 	edx,1
		call 	mio_writechar
		cmp 	edx,ecx
		je 		.ki
		jmp 	.writehex
	.tizfelett:
		add		eax,55
		mov 	[finalstring+edx],eax
		add 	edx,1
		call 	mio_writechar
		cmp 	edx,ecx
		je 		.ki
		jmp 	.writehex
	.ki:
		sub 	ecx,1
		mov 	[merethexstring],ecx
		mov 	eax,[minusz]
		cmp 	eax,48
		jne		.negativ
		ret
	.negativ:
		mov 	edx,0
		mov 	ecx,8
		call 	mio_writeln
		.ciklus:
			mov 	ebx,[merethexstring] 
			sub 	ebx,edx
			mov 	eax,[finalstring+ebx]
			call 	mio_writechar
			cmp 	eax,'9'
			jbe 	.szam
			jmp 	.betu
			.szam:
				cmp 	eax,53
				jbe 	.betu
				mov 	ebx,70
				sub 	ebx,eax
				add 	ebx,41
				push 	ebx
				mov 	eax,ebx
				call 	mio_writechar
				sub 	ecx,1 					;ecx--
				add 	edx,1					;edx++
				mov 	eax,[merethexstring]
				add 	eax,1
				cmp 	eax,edx
				je 		.felepit
				jmp 	.ciklus
			.betu:
				mov 	ebx,70
				sub 	ebx,eax
				add 	ebx,48
				mov 	eax,ebx
				call 	mio_writechar
				push 	ebx
				sub 	ecx,1
				add 	edx,1
				mov 	eax,[merethexstring]
				add 	eax,1
				cmp 	eax,edx
				je 		.felepit
				jmp 	.ciklus
			.felepit:
				mov 	ecx,8
				.ciklus123:
				cmp 	edx,ecx
				je 		.kilep
				mov 	eax,'F'
				push 	eax
				add 	edx,1
				jmp 	.ciklus123
				.kilep:
					mov ecx,0
					.ciklusasd:
					cmp 	ecx,8
					je 	.ret
					pop 	eax
					mov 	[Hexstr+ecx],eax
					inc 	ecx
					jmp 	.ciklusasd
					.ret:
						call 	mio_writeln
						mov 	eax,Hexstr
						call	mio_writestr
						ret
	

ret



section .data
    message db "Type something:", 0
	finalstring db "",0
	Hexstr 	db "",0
	merethexstring db 0
	meretx 	dd 0
	decim 	dd 0
	x:    
		db  0
		db  0
		db  0
		db 	0
		db 	0
	minusz dd 1