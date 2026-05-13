.

```
# HƯỚNG DẪN CÀI ĐẶT VÀ SỬ DỤNG `ish_lang_nghiem`

Repo: `ish_lang_nghiem`  
Dùng cho:

- MacBook
- Windows Git Bash
- iPhone iSH ip-1 = iPhone 14 Pro Max
- iPhone iSH ip-2 = iPhone XS

---

# 1. Quy ước thiết bị

```text
ip-1 = iPhone 14 Pro Max
ip-2 = iPhone XS
mac  = MacBook
win  = Windows
```

Trên iPhone 14 Pro Max:

```
echo "ip-1" > ~/.ish_device_name
cat ~/.ish_device_name
```

Trên iPhone XS:

```
echo "ip-2" > ~/.ish_device_name
cat ~/.ish_device_name
```

Trên Mac:

```
echo "mac" > ~/.ish_device_name
cat ~/.ish_device_name
```

Trên Windows Git Bash:

```
echo "win" > ~/.ish_device_name
cat ~/.ish_device_name
```

------

# 2. Cài repo trên iSH mới

Nếu iSH chưa có repo:

```
apk update
apk add git openssh bash nano curl

cd ~
git clone https://github.com/bsliem/ish_lang_nghiem.git
cd ~/ish_lang_nghiem
```

Nếu repo đã có:

```
cd ~/ish_lang_nghiem
git pull
```

------

# 3. Cài lệnh `c` — bò danh ngôn kinh điển

File chính:

```
scripts/cow_kinh_dien.sh
data/fortune_kinh_dien.txt
```

Cài trên Mac hoặc iSH:

```
cd ~/ish_lang_nghiem 2>/dev/null || cd ~/Documents/ish_lang_nghiem

chmod +x scripts/cow_kinh_dien.sh
bash scripts/setup_alias_c.sh
```

Nạp lại cấu hình.

Trên Mac:

```
source ~/.zshrc
```

Trên iSH:

```
source ~/.bashrc
```

Dùng:

```
c
ckd
bo
kinh
```

Ý nghĩa:

```
c    = câu kinh điển / cowsay kinh điển
ckd  = cowsay kinh điển
bo   = bò đọc danh ngôn
kinh = danh ngôn kinh điển
```

Thêm danh ngôn mới trong file:

```
data/fortune_kinh_dien.txt
```

Mỗi dòng là một câu.

Ví dụ:

```
Tâm bình thường là đạo. # 平常心・道
Đi chậm cũng được, miễn là đừng quay lui. # 精進・不退
Một câu kinh thấm vào tâm hơn ngàn lời nói suông. # 經句・入心
```

------

# 4. Cài lệnh `db` — tụng Chú Đại Bi

File chính:

```
dai_bi.md
scripts/db.sh
scripts/setup_db.sh
```

Cài trên Mac hoặc iSH:

```
cd ~/ish_lang_nghiem 2>/dev/null || cd ~/Documents/ish_lang_nghiem

chmod +x scripts/db.sh scripts/setup_db.sh
bash scripts/setup_db.sh
```

Nạp lại cấu hình.

Trên Mac:

```
source ~/.zshrc
```

Trên iSH:

```
source ~/.bashrc
```

Dùng:

```
db
db b0
db b1
db b2
db b3
db b4
db b5
db b6
db 13 24
```

Ý nghĩa block:

```
db b0 = câu 01–12
db b1 = câu 13–24
db b2 = câu 25–36
db b3 = câu 37–48
db b4 = câu 49–60
db b5 = câu 61–72
db b6 = câu 73–84
```

Dùng theo khoảng câu:

```
db 1 12
db 13 24
db 73 84
```

Thoát khi đang tụng:

```
q hoặc ESC
```

------

# 5. Cài lệnh `gp` — git pull rebase + add + commit + push

File chính:

```
scripts/gp.sh
scripts/setup_gp.sh
```

Cài trên Mac hoặc iSH:

```
cd ~/ish_lang_nghiem 2>/dev/null || cd ~/Documents/ish_lang_nghiem

chmod +x scripts/gp.sh scripts/setup_gp.sh
bash scripts/setup_gp.sh
```

Nạp lại cấu hình.

Trên Mac:

```
source ~/.zshrc
```

Trên iSH:

```
source ~/.bashrc
```

Dùng:

```
gp
```

Nếu không nhập message, `gp` sẽ tự dùng message theo thiết bị:

```
ip-1 → update all from ip-1
ip-2 → update all from ip-2
mac  → update all from mac
win  → update all from win
```

Dùng message riêng:

```
gp "fix db color"
gp "add fortune lines"
gp "update dai bi text"
```

`gp` sẽ tự chạy:

```
git pull --rebase --autostash
git add -A
git commit -m "message"
git pull --rebase --autostash
git push
```

------

# 6. Setup GitHub token trên iSH

Nếu `gp` hoặc `git push` hỏi:

```
Username for 'https://github.com':
```

nhập:

```
bsliem
```

Nếu hỏi:

```
Password for 'https://bsliem@github.com':
```

dán GitHub Personal Access Token.

Bật lưu token:

```
git config --global credential.helper store
```

Nếu nhập sai token, xóa credential cũ:

```
rm -f ~/.git-credentials
git config --global credential.helper store
git push
```

------

# 7. Sửa lỗi DNS trên iSH

Nếu gặp lỗi:

```
Could not resolve host: github.com
ping: bad address 'github.com'
```

Sửa DNS:

```
cat > /etc/resolv.conf <<'EOF'
nameserver 1.1.1.1
nameserver 8.8.8.8
EOF
```

Kiểm tra:

```
cat /etc/resolv.conf
ping -c 3 github.com
```

Nếu vẫn lỗi, thử DNS Google:

```
cat > /etc/resolv.conf <<'EOF'
nameserver 8.8.8.8
nameserver 8.8.4.4
EOF

ping -c 3 github.com
```

Nếu ping IP cũng không được:

```
ping -c 3 1.1.1.1
```

Nếu không ping được IP, iSH hoặc iPhone đang mất mạng. Tắt mở Wi-Fi hoặc đóng iSH mở lại.

------

# 8. Quy trình làm việc hằng ngày

## Trên Mac

```
cd ~/Documents/ish_lang_nghiem

# sửa file bằng RStudio
# ví dụ: dai_bi.md, scripts/db.sh, data/fortune_kinh_dien.txt

gp "update from mac"
```

## Trên iPhone 14 Pro Max ip-1

```
cd ~/ish_lang_nghiem
git pull

# sửa file nếu cần

gp
```

Message mặc định:

```
update all from ip-1
```

## Trên iPhone XS ip-2

```
cd ~/ish_lang_nghiem
git pull

# sửa file nếu cần

gp
```

Message mặc định:

```
update all from ip-2
```

------

# 9. Các lệnh cần nhớ

```
c
db b0
db b6
ln 0*
lnk "tát đát"
gp
gp "message"
```

Ý nghĩa:

```
c      = bò danh ngôn kinh điển
db     = tụng Chú Đại Bi
ln     = tụng Chú Lăng Nghiêm
lnk    = tìm trong Chú Lăng Nghiêm
gp     = pull rebase + add + commit + push
```

------

# 10. Kiểm tra nhanh hệ thống

```
cd ~/ish_lang_nghiem 2>/dev/null || cd ~/Documents/ish_lang_nghiem

which c
which db
which gp

c
db b0
gp "test setup"
```

Nếu `which db` hoặc `which gp` không ra gì, chạy lại setup:

```
bash scripts/setup_db.sh
bash scripts/setup_gp.sh
```

Rồi nạp lại:

```
source ~/.bashrc
```

hoặc trên Mac:

```
source ~/.zshrc
```

------

# 11. Dọn file tạm không cần thiết

Nếu có file backup:

```
dai_bi.md.bak
```

có thể xóa:

```
rm -f dai_bi.md.bak
```

Nếu có file Word tạm bắt đầu bằng `~$`, có thể xóa:

```
rm -f "~$"*
```

------

# 12. Lời nhắc

```
Mac viết code.
GitHub làm trung gian.
iPhone 1 và iPhone 2 chỉ cần git pull.
Sửa xong thì gp.
ip-1 = iPhone 14 Pro Max
ip-2 = iPhone XS
```

Nam Mô A Di Đà Phật.

```
Sau khi dán xong, chạy:

```bash
cd ~/Documents/ish_lang_nghiem
git add scripts/huong_dan_cai_dat.md
git commit -m "add setup guide"
git push
```











<audio class="fixed start-0 bottom-0 hidden h-0 w-0" autoplay="" crossorigin="anonymous"></audio>