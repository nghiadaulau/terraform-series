# Terraform Từ Cơ Bản Đến Thực Chiến — code & lab

Repo này chứa toàn bộ code hands-on đi kèm series blog **"Terraform Từ Cơ Bản Đến Thực Chiến"** trên [kkloudtarus.net](https://kkloudtarus.net).

Mỗi thư mục `NN-*` tương ứng một bài trong series. Code được test thật trên AWS (free-tier khi có thể), mọi bài hands-on đều có bước dọn dẹp (`terraform destroy`).

## Phiên bản dùng trong series

| Thành phần | Phiên bản |
|---|---|
| Terraform | `1.15.4` |
| AWS Provider (`hashicorp/aws`) | `6.46.0` (pin `~> 6.0`) |
| Cloud | AWS |

Provider được pin trong từng bài để kết quả tái lập được. Khi bạn đọc, phiên bản mới hơn có thể đã ra — hãy đọc release notes trước khi nâng.

## Yêu cầu

- Tài khoản AWS + AWS CLI đã cấu hình (`aws configure`).
- Terraform `>= 1.10` (một số tính năng như `use_lockfile`, ephemeral resources cần bản mới).

## Cấu trúc

```
NN-ten-bai/        # code của bài NN
  main.tf
  variables.tf
  outputs.tf
  ...
```

## Lưu ý chi phí

Lab bám free-tier. Một số bài (RDS, ALB, NAT Gateway ở capstone) có thể phát sinh phí nhỏ nếu để chạy lâu — luôn `terraform destroy` sau khi thực hành xong.

---

Tác giả: [nghiadaulau](https://github.com/nghiadaulau) · Blog: [kkloudtarus.net](https://kkloudtarus.net)
