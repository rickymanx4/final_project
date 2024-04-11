[Unit]
Description=project Blind python Service
After=multi-user.target

[Service]
Type=idle
WorkingDirectory=/home/ec2-user/service/blind_was
ExecStart=/usr/bin/python3 -u /home/ec2-user/service/blind_was/blind.py
StandardOutput=file:/home/ec2-user/service/blind_was/blind_was_access.log 
StandardError=file:/home/ec2-user/service/blind_was/blind_was_error.log 


[Install]
WantedBy=multi-user.target