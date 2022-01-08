# 期末專題：簡易記帳工具

> 組員：胡尹瑄、吳少熹、陳禾旻、黃昱智

[Toc]

# 1.  簡介

- 以**命令列工具（Command Line Tool, CLT）**的方式來實作

## 功能

- **新增**資料
- **刪除**資料
- **修改**資料
- **搜尋**資料
- 顯示**統計**
- **儲存**資料（上限 500 筆）

![](https://i.imgur.com/REZEpmy.png)

# 2.  程式

## 引用函式庫：`Irvine32.inc`

## 架構

1. 當使用者開啟程式，會進入到**主選單**，並顯示**記錄筆數**
2. 使用者透過輸入數字（1 ~ 5）來選擇功能，若選擇離開，則輸入 6
3. 若使用者選擇結束程式，程式會將新增的資料寫入到 .txt 檔中

![](https://i.imgur.com/E3aXtR8.png=)

## 資料格式

- 我們透過 **structure** 儲存每一筆資料
- 資料內容

<script src="https://gist.github.com/SonodaKazuto/61bd7678059d8643c40fe9f2e74db692.js"></script>

| 變數名稱 | 變數型態 |  |
| --- | --- | --- |
| Index | WORD | 資料的序號，便於查找資料 |
| Content | BYTE | 花費的內容 |
| ContentSize | DWORD | Content的字串長度 |
| Year、Month、Day | WORD | 花費產生的日期 |
| Expense | DWORD | 花費金額 |
| Category | BYTE | 分類 |



## 功能實作

### 新增

### 刪除

### 修改

### 查詢

### 統計

# 心得
