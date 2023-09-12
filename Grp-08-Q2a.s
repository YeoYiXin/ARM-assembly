	AREA ownmerge, CODE, READONLY
	ENTRY
	
	; int size = 10;
	MOV r0, #10
	
	; int level = 1;
	MOV r1, #1
	
LOOP
	; level *= 2;
	MOV r1, r1, LSL #1
	
	; int i = 0;
	MOV r2, #0
	
LOOP1
	
	; if (i >= size) break;
	CMP r2, r0
	BGE	END_LOOP1
	
	; j = i + 1;
	ADD r3, r2, #1

LOOP2

	; if (j >= i + level) break;
	ADD r10, r2, r1
	CMP r3, r10
	BGE END_LOOP2

	; if (j >= size) break;
	CMP r3, r0
	BGE END_LOOP2
	
	; int key = arr[j];
	ADR r12, datalist
	ADD r12, r12, r3
	LDRB r12, [r12]
	
	; int k = j - 1;
	SUB r4, r3, #1
	
LOOP3
	
	; if (k < i) break;
	CMP r4, r2
	BLT END_LOOP3
	
	; int val = arr[k];
	ADR r11, datalist
	ADD r11, r11, r4
	LDRB r9, [r11]
	
	; if (val <= key) break;
	CMP r9, r12
	BLE END_LOOP3
	
	; arr[k + 1] = val;
	STRB r9, [r11, #1]
	
	; k--;
	SUB r4, r4, #1
	SUB r11, r11, #1
	
	B LOOP3
	
END_LOOP3
	; arr[k + 1] = key;
	STRB r12, [r11, #1]
	
	; j++;
	ADD r3, r3, #1
	
	B LOOP2
	
END_LOOP2
	; i += level;
	ADD r2, r2, r1
	
	B LOOP1
	
END_LOOP1
	; if (level >= size) goto END;
	CMP r1, r0
	BGE stop
	
	B LOOP
	
stop B stop

	AREA ownmerge, DATA, READWRITE		
datalist DCB 8, 29, 50, 81, 4, 23, 24, 30, 1, 7		; array
	END

; void mergeSort(int arr[], int size) {
; 	  int i;
;     int level = 1;
;     do {
;         level *= 2;
;         int i = 0;
;         while(1) {
;             if (i >= size) break;
;             int j = i + 1;
;             while (1) {
;                 if (j >= i + level) break;
;                 if (j >= size) break;
;                 int key = arr[j];
;                 int k = j - 1;
;                 while (1) {
;                     if (k < i) break;
;                     int val = arr[k];
;                     if (val <= key) break;
;                     arr[k + 1] = val;
;                     k--;
;                 }
;                arr[k + 1] = key;
;                j++;
;             }
;         i += level;
;         }
;     } while (level < size);
; }
