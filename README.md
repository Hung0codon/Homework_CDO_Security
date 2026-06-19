# Bài tập: Phát hiện Dữ liệu Nhạy cảm trên Amazon S3 bằng Amazon Macie và Gửi Cảnh báo Email

Dự án này sử dụng Terraform để tự động hóa việc triển khai toàn bộ hệ thống phát hiện dữ liệu nhạy cảm trên S3 và gửi thông báo qua Email:
1. Khởi tạo một S3 Bucket bảo mật.
2. Tải lên tệp CSV mẫu có chứa các thông tin nhạy cảm giả lập (Credit Card, SSN, Email, v.v.).
3. Kích hoạt Amazon Macie và tạo một Macie Classification Job để quét S3 Bucket đó.
4. Thiết lập EventBridge Rule bắt các findings (phát hiện) từ Macie.
5. Gửi thông báo đến SNS Topic và gửi email cảnh báo về địa chỉ email của bạn.

---

## 📁 Cấu trúc Thư mục

- `main.tf`: Chứa định nghĩa tài nguyên AWS (S3, Macie, EventBridge, SNS, Policies).
- `variables.tf`: Các biến cấu hình cho dự án.
- `outputs.tf`: Kết quả đầu ra của Terraform sau khi khởi tạo thành công.
- `terraform.tfvars`: Tệp cấu hình email nhận thông báo và AWS Region.
- `sample_files/sensitive_data.csv`: Tệp dữ liệu mẫu chứa thông tin nhạy cảm giả lập (Credit Card, SSN).

---

## 🚀 Các Bước Thực Hiện

### Bước 1: Cấu hình Biến môi trường
Cập nhật tệp `terraform.tfvars` bằng cách thay đổi địa chỉ email của bạn và AWS Region (nếu cần):
```hcl
aws_region  = "ap-southeast-1" # Chọn region bạn muốn chạy (ví dụ: ap-southeast-1, us-east-1,...)
alert_email = "email_cua_ban@example.com" # Điền email nhận cảnh báo thực tế của bạn
```

### Bước 2: Triển khai Terraform
Mở Terminal trong thư mục này và chạy các lệnh sau:

1. Khởi tạo các provider:
   ```bash
   terraform init
   ```
2. Kiểm tra tài nguyên chuẩn bị tạo:
   ```bash
   terraform plan
   ```
3. Triển khai tài nguyên lên AWS:
   ```bash
   terraform apply
   ```
   *(Gõ `yes` khi được hỏi để xác nhận triển khai)*

### Bước 3: Xác nhận Đăng ký Email (BẮT BUỘC)
Sau khi `terraform apply` thành công, AWS sẽ gửi một email xác nhận (Subscription Confirmation) từ AWS Notifications đến hòm thư của bạn.
1. Mở email của bạn (kiểm tra cả hộp thư **Spam/Thư rác** nếu không thấy).
2. Click vào liên kết **Confirm Subscription** để cho phép nhận thông báo từ SNS Topic.

### Bước 4: Kiểm tra kết quả quét của Amazon Macie
1. Đăng nhập vào AWS Console và chuyển đến dịch vụ **Amazon Macie**.
2. Chọn **Jobs** ở menu bên trái. Bạn sẽ thấy một Job tên là `cdo-macie-sensitive-data-job-...` đang hoặc đã chạy.
3. Chờ vài phút để Job hoàn thành. Sau khi hoàn thành, chọn **Findings** để xem các dữ liệu nhạy cảm đã bị phát hiện (như Credit Card, SSN, v.v.).
4. **Chụp ảnh màn hình 1**: Minh chứng phát hiện dữ liệu nhạy cảm (detect) trong Macie console.

### Bước 5: Kiểm tra Email Cảnh báo
1. Sau khi Macie sinh ra Findings, EventBridge sẽ bắt sự kiện và gửi email thông báo qua SNS.
2. Kiểm tra hòm thư email của bạn, bạn sẽ nhận được một email chứa thông tin chi tiết về Finding từ Macie.
3. **Chụp ảnh màn hình 2**: Email thông báo cảnh báo gửi về Mail của bạn.

---

## 🧹 Dọn dẹp Tài nguyên

Sau khi đã chụp đủ ảnh và hoàn thành bài tập, hãy hủy các tài nguyên để tránh phát sinh chi phí AWS ngoài ý muốn:
```bash
terraform destroy
```
*(Gõ `yes` để xác nhận xóa sạch tài nguyên)*
