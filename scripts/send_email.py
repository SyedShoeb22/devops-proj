import smtplib
from email.mime.text import MIMEText
import csv, sys

def send_email(to_addr, subject, body, smtp_user, smtp_pass):
    msg = MIMEText(body)
    msg['From'] = smtp_user
    msg['To'] = to_addr
    msg['Subject'] = subject
    with smtplib.SMTP_SSL('smtp.gmail.com', 465) as server:
        server.login(smtp_user, smtp_pass)
        server.send_message(msg)

if __name__ == "__main__":
    csv_path = sys.argv[1]
    smtp_user = sys.argv[2]
    smtp_pass = sys.argv[3]
    instance_ip = sys.argv[4]

    with open(csv_path) as f:
        reader = csv.reader(f)
        for row in reader:
            username, password = row
            email_body = f"""
Your account details:

Server IP: {instance_ip}
Username: {username}
Password: {password}
"""
            # Replace with your logic to get recipient email
            recipient = f"{username}@domain.com"
            send_email(recipient, "Your server credentials", email_body, smtp_user, smtp_pass)
