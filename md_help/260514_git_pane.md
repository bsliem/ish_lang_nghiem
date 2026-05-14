**manual dùng Git pane trong RStudio** theo đúng workflow hôm nay của anh.

```
# MANUAL: Dùng Git pane trong RStudio hiệu quả

## 1. Mục tiêu

Git pane trong RStudio dùng để thao tác Git bằng chuột:

- Xem file nào đã thay đổi
- Xem nội dung thay đổi bằng Diff
- Stage file cần commit
- Commit thay đổi
- Push lên GitHub
- Pull thay đổi mới từ GitHub
- Xem lịch sử commit

Nguyên tắc chung:

- Git pane dùng cho thao tác hằng ngày.
- Terminal dùng cho tình huống khó: conflict, rebase, reset, stash, non-fast-forward.

---

## 2. Các nút quan trọng trong Git pane

### Pull

Dùng để kéo thay đổi mới nhất từ GitHub về máy.

Nên bấm Pull trước khi bắt đầu làm việc.

Tương đương terminal:

```bash
git pull
```

------

### Push

Dùng để đẩy commit từ máy lên GitHub.

Chỉ Push sau khi đã Commit.

Tương đương terminal:

```
git push
```

------

### Diff

Dùng để xem file đã thay đổi chỗ nào.

Màu xanh lá:

- Dòng mới thêm vào.

Màu đỏ:

- Dòng bị xóa.

Màu xám / trắng:

- Dòng ngữ cảnh, không thay đổi.

Tương đương terminal:

```
git diff
```

------

### Stage

Dùng để chọn file đưa vào commit.

Tương đương terminal:

```
git add ten_file
```

Nếu chọn tất cả:

```
git add .
```

------

### Commit

Dùng để lưu thay đổi vào lịch sử Git.

Tương đương terminal:

```
git commit -m "noi dung commit"
```

------

### History

Dùng để xem lịch sử commit.

Trong History, nếu thấy:

```
HEAD -> refs/heads/main
origin/main
origin/HEAD
```

nghĩa là máy local và GitHub đang đồng bộ ở commit mới nhất.

------

## 3. Hiểu các ký hiệu trạng thái file

Trong Git pane, cột Status có các ký hiệu:

```
M = Modified  = file đã sửa
A = Added     = file mới được thêm
D = Deleted   = file đã bị xóa
? = Untracked = file mới, Git chưa theo dõi
R = Renamed   = file đổi tên
```

Ví dụ hôm nay:

```
D output/~$nh_muc_51_dich_vu_ky_thuat_YHCT_TT23_20260511.docx
D output/docx/~$_quy_trinh_ky_thuat_YHCT_51_dich_vu_20260511.docx
```

Hai file này là file Word tạm, có tên bắt đầu bằng:

```
~$
```

Đây là file lock/cache do Microsoft Word tạo ra, không phải file tài liệu chính thức.

------

## 4. Workflow chuẩn mỗi ngày

### Bước 1. Pull trước khi làm

Trước khi sửa file:

```
Bấm Pull
```

Mục đích:

- Lấy bản mới nhất từ GitHub
- Tránh sửa trên bản cũ
- Giảm nguy cơ conflict

------

### Bước 2. Sửa file trong RStudio

Có thể sửa:

- .R
- .qmd
- .Rmd
- .md
- .gitignore
- .bib
- .csl
- file cấu hình
- file báo cáo

------

### Bước 3. Xem Git pane

Sau khi sửa, nhìn Git pane.

Nếu thấy:

```
M .gitignore
```

nghĩa là file `.gitignore` đã được sửa.

Nếu thấy:

```
D file.docx
```

nghĩa là file đã bị xóa.

Nếu thấy:

```
? file_moi.R
```

nghĩa là file mới, Git chưa theo dõi.

------

### Bước 4. Bấm Diff để kiểm tra

Trước khi commit, nên xem Diff.

Màu xanh lá là nội dung mới thêm.

Ví dụ hôm nay thêm vào `.gitignore`:

```
# Word / Office temporary lock files
~$*
**/~$*
~$*.docx
**/~$*.docx
~$*.xlsx
**/~$*.xlsx
~$*.pptx
**/~$*.pptx
```

Nghĩa là từ nay Git sẽ bỏ qua các file tạm của Word, Excel, PowerPoint.

------

### Bước 5. Stage file

Có 2 cách:

#### Cách 1: Tick từng file

Trong Git pane, tick vào ô vuông ở cột Staged.

Dùng khi chỉ muốn commit vài file cụ thể.

#### Cách 2: Stage All

Trong cửa sổ Review Changes, bấm:

```
Stage All
```

Dùng khi chắc chắn muốn commit toàn bộ thay đổi đang hiện.

Hôm nay chỉ có `.gitignore`, nên dùng Stage All là đúng.

------

### Bước 6. Viết commit message

Commit message nên ngắn, rõ, dễ hiểu.

Ví dụ tốt:

```
Ignore Office temporary files
```

Hoặc tiếng Việt không dấu:

```
Chan file tam Office
```

Hoặc như hôm nay:

```
bo file tam office
```

Nên tránh message quá ngắn kiểu:

```
y
ok
update
sua
```

Trừ khi đang làm rất nhanh và không cần lịch sử rõ.

------

### Bước 7. Commit

Sau khi đã stage và viết message:

```
Bấm Commit
```

Nếu thành công, RStudio sẽ hiện dòng tương tự:

```
[main ca42148] bo file tam office
1 file changed, 10 insertions(+)
```

Nghĩa là commit đã được tạo thành công trên máy local.

------

### Bước 8. Push

Sau khi commit:

```
Bấm Close
Bấm Push
```

Nếu Push thành công, RStudio sẽ hiện dòng kiểu:

```
e1b1750..ca42148  HEAD -> main
```

Nghĩa là commit đã được đẩy lên GitHub.

------

### Bước 9. Kiểm tra sạch

Sau khi Push, Git pane không còn file nào hiện ra là tốt.

Có thể kiểm tra bằng Terminal:

```
git status
```

Kết quả đẹp:

```
On branch main
Your branch is up to date with 'origin/main'.

nothing to commit, working tree clean
```

------

## 5. Quy trình hôm nay đã làm

### Việc 1: Xóa file Word tạm

Git pane báo 2 file:

```
D output/~$nh_muc_51_dich_vu_ky_thuat_YHCT_TT23_20260511.docx
D output/docx/~$_quy_trinh_ky_thuat_YHCT_51_dich_vu_20260511.docx
```

Đây là file Word tạm.

Thao tác đã làm:

```
Tick 2 file D
Commit message: Loại bỏ file words sach
Commit
Push
```

Kết quả:

```
2 files changed
delete mode ...
HEAD -> main
```

Nghĩa là GitHub đã nhận việc xóa 2 file tạm.

------

### Việc 2: Thêm .gitignore để chặn file tạm Office

File `.gitignore` ban đầu có:

```
.Rproj.user
.Rhistory
.RData
.Ruserdata
```

Đã thêm:

```
# Word / Office temporary lock files
~$*
**/~$*
~$*.docx
**/~$*.docx
~$*.xlsx
**/~$*.xlsx
~$*.pptx
**/~$*.pptx
```

Thao tác đã làm:

```
Save .gitignore
Git pane thấy M .gitignore
Bấm Review Changes / Commit
Bấm Stage All
Commit message: bo file tam office
Commit
Push
```

Kết quả:

```
[main ca42148] bo file tam office
1 file changed, 10 insertions(+)
```

Push thành công:

```
e1b1750..ca42148  HEAD -> main
```

------

## 6. Cách hiểu màn hình History

Trong History, commit mới nhất hiện:

```
HEAD -> refs/heads/main
origin/main
origin/HEAD
bo file tam office
```

Ý nghĩa:

```
HEAD -> refs/heads/main
```

Máy local đang đứng tại commit mới nhất của nhánh main.

```
origin/main
```

GitHub cũng đang ở commit này.

```
origin/HEAD
```

Nhánh mặc định trên GitHub cũng trỏ về commit này.

Kết luận:

```
Local main và GitHub main đã đồng bộ.
```

------

## 7. Khi nào nên dùng Git pane?

Nên dùng Git pane cho:

```
Pull
Diff
Stage
Commit
Push
History
```

Rất phù hợp khi làm việc trong RStudio với:

```
R script
Quarto
Markdown
Word output
file cấu hình
.gitignore
```

------

## 8. Khi nào nên dùng Terminal?

Nên dùng Terminal khi gặp các tình huống khó:

```
Conflict
Rebase
Reset hard
Stash
Non-fast-forward
Divergent branches
Untracked files would be overwritten
GPG signing error
Đổi remote
Xử lý branch phức tạp
```

Ví dụ lệnh kiểm tra an toàn:

```
git status
```

Ví dụ kiểm tra lịch sử:

```
git log --oneline --graph --decorate -10
```

------

## 9. Quy tắc an toàn khi dùng Git pane

### Không bấm Discard nếu chưa chắc

Các nút nguy hiểm:

```
Discard All
Discard chunk
Revert
```

Các nút này có thể làm mất thay đổi chưa commit.

Nếu chưa chắc, không bấm.

------

### Luôn xem Diff trước khi Commit

Trước khi commit, nên nhìn qua Diff để biết mình đang đưa gì vào Git.

------

### Không commit file tạm

Không commit:

```
~$*.docx
~$*.xlsx
~$*.pptx
.Rhistory
.RData
.DS_Store
file backup
file tạm
```

------

### Cẩn thận với output

Các file output như:

```
output/*.docx
output/*.pdf
output/*.html
```

Chỉ commit khi đó là bản kết quả chính thức cần lưu.

Nếu chỉ là file render thử, không cần commit.

------

## 10. Công thức nhớ nhanh

Workflow chuẩn:

```
Pull
→ sửa file
→ xem Git pane
→ Diff
→ Stage
→ Commit
→ Push
→ kiểm tra History
```

Công thức hôm nay:

```
File D = file đã xóa
Tick file D = chấp nhận việc xóa
Commit = lưu việc xóa vào Git
Push = đưa việc xóa lên GitHub
```

Với `.gitignore`:

```
M .gitignore = file ignore đã sửa
Stage All = chọn thay đổi
Commit = lưu rule ignore
Push = đưa rule lên GitHub
```

------

## 11. Bộ .gitignore khuyên dùng cho repo RStudio

```
# RStudio / R
.Rproj.user
.Rhistory
.RData
.Ruserdata

# macOS
.DS_Store

# Word / Office temporary lock files
~$*
**/~$*
~$*.docx
**/~$*.docx
~$*.xlsx
**/~$*.xlsx
~$*.pptx
**/~$*.pptx

# Quarto cache
*_cache/
*_files/

# Temporary files
*.tmp
*.bak
```

------

## 12. Kết luận

Git pane trong RStudio rất mạnh nếu dùng đúng vai trò:

```
Dùng Git pane để nhìn rõ thay đổi và commit nhanh.
Dùng Terminal để xử lý ca khó.
```

Quy trình tốt nhất cho anh:

```
Pull đầu buổi
Sửa file
Diff kỹ
Stage đúng file
Commit message rõ
Push cuối buổi
History kiểm tra đồng bộ
```