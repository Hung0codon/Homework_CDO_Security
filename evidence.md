# BÁO CÁO KẾT QUẢ BÀI TẬP (EVIDENCE)
## Đề tài: Phát hiện Dữ liệu Nhạy cảm trên Amazon S3 bằng Amazon Macie và Gửi Cảnh báo Email

- **Họ và tên:** [Lê Viết Quốc Hưng]
- **Email nhận cảnh báo:** quochungisme@gmail.com

---

## 1. Kết quả Phát hiện Dữ liệu Nhạy cảm trong Amazon Macie (Detect)

*Mô tả:bảng điều khiển Amazon Macie chỉ ra các Findings (phát hiện) dữ liệu nhạy cảm (Credit Cards, SSN, v.v.) bên trong tệp tin `sensitive_data.csv` trên S3 Bucket.*

<img width="1608" height="744" alt="image" src="https://github.com/user-attachments/assets/833439b1-124e-446c-bdc1-504420691436" />


---

## 2. Kết quả Cảnh báo gửi về Mail (Mail Notification Alert)

*Mô tả:màn hình email thông báo nhận được trong hòm thư cá nhân từ dịch vụ AWS Notifications (thông qua SNS & EventBridge) cảnh báo chi tiết về các Findings mà Amazon Macie phát hiện được.*

<img width="1474" height="602" alt="image" src="https://github.com/user-attachments/assets/31243eeb-80b9-42b1-b048-7e6c95abc58b" />


## 🛠️ Chi tiết Tài nguyên đã Triển khai (Terraform Outputs)

```hcl
alert_email    = "quochungisme@gmail.com"
macie_job_id   = "811298091cbc64de2e1a627b35037089"
s3_bucket_name = "cdo-macie-sensitive-data-6f164f5dd336"
sns_topic_arn  = "arn:aws:sns:ap-southeast-1:945125812908:cdo-macie-alerts-topic-6f164f5dd336"
sns_topic_name = "cdo-macie-alerts-topic-6f164f5dd336"
```
