# BÁO CÁO KẾT QUẢ BÀI TẬP (EVIDENCE)
## Đề tài: Phát hiện Dữ liệu Nhạy cảm trên Amazon S3 bằng Amazon Macie và Gửi Cảnh báo Email

- **Họ và tên:** [Điền họ và tên của bạn]
- **Email nhận cảnh báo:** quochungisme@gmail.com
- **Repository Github:** [Dán link repo Github của bạn ở đây]

---

## 1. Kết quả Phát hiện Dữ liệu Nhạy cảm trong Amazon Macie (Detect)

*Mô tả: Hình ảnh chụp màn hình bảng điều khiển Amazon Macie chỉ ra các Findings (phát hiện) dữ liệu nhạy cảm (Credit Cards, SSN, v.v.) bên trong tệp tin `sensitive_data.csv` trên S3 Bucket.*

> [!TIP]
> Lưu ảnh chụp màn hình Macie của bạn với tên `macie_detect.png` đặt trong thư mục này và thay thế đường dẫn bên dưới (hoặc dán ảnh trực tiếp vào).

![Amazon Macie Detect](macie_detect.png)

---

## 2. Kết quả Cảnh báo gửi về Mail (Mail Notification Alert)

*Mô tả: Hình ảnh chụp màn hình email thông báo nhận được trong hòm thư cá nhân từ dịch vụ AWS Notifications (thông qua SNS & EventBridge) cảnh báo chi tiết về các Findings mà Amazon Macie phát hiện được.*

> [!TIP]
> Lưu ảnh chụp màn hình Email nhận cảnh báo với tên `email_alert.png` đặt trong thư mục này và thay thế đường dẫn bên dưới (hoặc dán ảnh trực tiếp vào).

![Email Notification Alert](email_alert.png)

---

## 🛠️ Chi tiết Tài nguyên đã Triển khai (Terraform Outputs)

```hcl
alert_email    = "quochungisme@gmail.com"
macie_job_id   = "811298091cbc64de2e1a627b35037089"
s3_bucket_name = "cdo-macie-sensitive-data-6f164f5dd336"
sns_topic_arn  = "arn:aws:sns:ap-southeast-1:945125812908:cdo-macie-alerts-topic-6f164f5dd336"
sns_topic_name = "cdo-macie-alerts-topic-6f164f5dd336"
```
