TITLE FinalProject
INCLUDE Irvine32.inc

Item STRUCT
	Content BYTE 30 DUP(?)
	Year WORD ?
	Month WORD ?
	Day WORD ?
	Expense BYTE 20 DUP(?)
	Category BYTE 20 DUP(?)
Item ENDS

.data

main EQU start@0
.code
	main PROC

	exit
main ENDP
END main