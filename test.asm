INCLUDE Irvine32.inc
main EQU start@0

Item STRUCT
	Index WORD ?
	Content BYTE 50 DUP(0)
	Year WORD ?
	Month WORD ?
	Day WORD ?
	Expense DWORD ?
	Category BYTE ?
Item ENDS

.data
data Item 500 DUP(<>)
filename BYTE "AccountingBook.txt",0
titleStr BYTE "Accounting book",0
titleSize DWORD $-titleStr
optionStr BYTE "Please Choose Option:",0
optionSize DWORD $-optionStr
options BYTE "Options: (1)Add (2)Delete (3)Modify (4)Search (5)Data (6)Exit",0
optionsSize DWORD $-options
errorMsg BYTE "Invalid Option!",0
errorMsgSize DWORD $-errorMsg
dateStr BYTE "Please Input Date:",0
dateSize DWORD $-dateStr
slash BYTE "/",0
slashSize DWORD $-slash
categoryStr BYTE "Please Choose Category:",0
categorySize DWORD $-categoryStr
categories BYTE "Category: (1)Food (2)Traffic (3)Entertainment (4)Shopping (5)Medical (6)Home (7)Learning",0
categoriesSize DWORD $-categories
itemStr BYTE "Please Input Item:",0
itemSize DWORD $-itemStr
priceStr BYTE "Please Input Price:",0
priceSize DWORD $-priceStr
curSizeStr BYTE "Current Items Quantity(MAX: 500 items):",0
curSizeSize DWORD $-curSizeStr
itemsQ DWORD 0

buffer BYTE 50 DUP(0)
bufferSize DWORD ?

inputHandle DWORD ?
outputHandle DWORD ?
fileHandle DWORD ?
optHandle DWORD ?
catHandle DWORD ?
count DWORD 0
bytesWritten DWORD ?
xyPosition COORD <0,0>

cellsWritten DWORD ?
attributes0 WORD 6 DUP(0Ch), 4 DUP(0Eh), 6 DUP(0Bh)
attributes1 WORD 14 DUP(0Fh)
.code
main PROC
	;Title
	INVOKE SetConsoleTitle, ADDR titleStr
	
	;Get Handle
	INVOKE GetStdHandle, STD_INPUT_HANDLE
	mov inputHandle, eax
	INVOKE GetStdHandle, STD_OUTPUT_HANDLE
	mov outputHandle, eax

START:
	;reset xyPosition
	mov xyPosition.x, 0
	mov xyPosition.y,0

	;clear screen
	call Clrscr
	
	;current items quantity
	INVOKE WriteConsoleOutputCharacter, outputHandle, ADDR curSizeStr, curSizeSize, xyPosition, ADDR bytesWritten
	add xyPosition.x, SIZEOF curSizeStr
	INVOKE SetConsoleCursorPosition, outputHandle, xyPosition
	mov eax, itemsQ
	call WriteDec
	
OPT:
	;option
	mov xyPosition.x, 0
	add xyPosition.y, 2
	INVOKE WriteConsoleOutputCharacter, outputHandle, ADDR options, optionsSize, xyPosition, ADDR bytesWritten
	inc xyPosition.y
	INVOKE WriteConsoleOutputCharacter, outputHandle, ADDR optionStr, optionSize, xyPosition, ADDR bytesWritten
	add xyPosition.x, SIZEOF optionStr
	INVOKE SetConsoleCursorPosition, outputHandle, xyPosition
	call ReadDec
	mov optHandle, eax
	.IF eax > 6
		mov xyPosition.x, 0
		add xyPosition.y, 2
		INVOKE WriteConsoleOutputCharacter, outputHandle, ADDR errorMsg, errorMsgSize, xyPosition, ADDR bytesWritten
		jmp OPT
	.ENDIF
	.IF eax == 1
		inc itemsQ
	.ENDIF
	.IF eax == 2
		dec itemsQ
	.ENDIF
	.IF eax == 5
		jmp SHOW_DATA
	.ENDIF
	.IF eax == 6
		jmp DONE
	.ENDIF
	mov eax, count
	mov ebx, itemsQ
	mov (Item PTR [data+eax]).Index, bx

CAT:
	;category
	mov xyPosition.x, 0
	add xyPosition.y, 2
	INVOKE WriteConsoleOutputCharacter, outputHandle, ADDR categories, categoriesSize, xyPosition, ADDR bytesWritten
	inc xyPosition.y
	INVOKE WriteConsoleOutputCharacter, outputHandle, ADDR categoryStr, categorySize, xyPosition, ADDR bytesWritten
	add xyPosition.x, SIZEOF categoryStr
	INVOKE SetConsoleCursorPosition, outputHandle, xyPosition
	call ReadDec
	.IF eax > 7
		mov xyPosition.x, 0
		add xyPosition.y, 2
		INVOKE WriteConsoleOutputCharacter, outputHandle, ADDR errorMsg, errorMsgSize, xyPosition, ADDR bytesWritten
		jmp CAT
	.ENDIF

	;date
	mov xyPosition.x, 0
	add xyPosition.y, 2
	INVOKE WriteConsoleOutputCharacter, outputHandle, ADDR dateStr, dateSize, xyPosition, ADDR bytesWritten
	add xyPosition.X, SIZEOF dateStr
	mov ecx, 3
DAT:
	push ecx
	INVOKE SetConsoleCursorPosition, outputHandle, xyPosition
	;mov edx, OFFSET buffer 
    ;mov ecx, (SIZEOF buffer) - 1
    ;call ReadString
	call ReadDec
	cmp eax, 100
	pop ecx
	push eax
	push ecx
	jb NotYear
    add xyPosition.x, 2
NotYear:
	add xyPosition.x, 2
	pop ecx
	cmp ecx, 1
	push ecx
	je DAT_STOP
	INVOKE WriteConsoleOutputCharacter, outputHandle, ADDR slash, slashSize, xyPosition, ADDR bytesWritten
	inc xyPosition.x
DAT_STOP:
	pop ecx
	loop DAT
	.IF optHandle == 1
		mov eax, count
		pop ebx
		mov (Item PTR [data+eax]).Day, bx
		pop ebx
		mov (Item PTR [data+eax]).Month, bx
		pop ebx
		mov (Item PTR [data+eax]).Year, bx
	.ENDIF

	;item
	mov xyPosition.x, 0
	add xyPosition.y, 2
	INVOKE WriteConsoleOutputCharacter, outputHandle, ADDR itemStr, itemSize, xyPosition, ADDR bytesWritten
	add xyPosition.x, SIZEOF itemStr
	INVOKE SetConsoleCursorPosition, outputHandle, xyPosition
	mov edx, OFFSET buffer 
    mov ecx, (SIZEOF buffer) - 1
    call ReadString
	mov ecx, eax
	.IF optHandle == 1
		mov eax, count
		cld
		mov esi, OFFSET buffer
		lea edi, (Item PTR [data+eax]).Content
		rep movsb
	.ENDIF
	
	;price
	mov xyPosition.x, 0
	add xyPosition.y, 2
	INVOKE WriteConsoleOutputCharacter, outputHandle, ADDR priceStr, priceSize, xyPosition, ADDR bytesWritten
	add xyPosition.x, SIZEOF priceStr
	INVOKE SetConsoleCursorPosition, outputHandle, xyPosition
	call ReadDec
	.IF optHandle == 1
		mov ebx, count
		mov (Item PTR [data+ebx]).Expense, eax
	.ENDIF
	;count++
	add count, TYPE data
	
del_item:
	
	
	jmp START
SHOW_DATA:
	mov ebx, 0
	mov ecx, itemsQ
L:
	mov ax, (Item PTR [data+ebx]).Index
	call WriteDec
	mov al, ' '
	call WriteChar
	call WriteChar
	mov ax, (Item PTR [data+ebx]).Year
	call WriteDec
	mov al, '/'
	call WriteChar
	mov ax, (Item PTR [data+ebx]).Month
	call WriteDec
	mov al, '/'
	call WriteChar
	mov ax, (Item PTR [data+ebx]).Day
	call WriteDec
	mov al, ' '
	call WriteChar
	call WriteChar
	lea edx, (Item PTR [data+ebx]).Content
	call WriteString
	mov al, ' '
	call WriteChar
	call WriteChar
	mov eax, (Item PTR [data+ebx]).Expense
	call WriteDec
	call Crlf
	add ebx, TYPE data
	dec ecx
	jnz L
	call WaitMsg
	jmp START
DONE:
	INVOKE CreateFile, ADDR filename, GENERIC_WRITE, DO_NOT_SHARE, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0
	call WaitMsg
	exit
main ENDP
END main