# Wallpapers_Script

Bash scripts to download Nasa and bing wallpapers everyday for gnome desktop environments.  
This project has been forked from [JoshSchreuder's gist](https://gist.github.com/JoshSchreuder/882666) and 
[whizzkids repo](https://github.com/whizzzkid/bing-wallpapers-for-linux).

## Steps

1. Clone this repository into a hidden folder in your Home directory (my preferred choice)  
   but can be any other directory.
2. Run the [setup_script.sh](./setup_script.sh) and supply an argument for the path of your working directory. This will create a hidden shell file to store the Repository's folder location.
```bash
git clone https://github.com/DhruvKoolRajamani/Wallpapers_Script.git ~/.Wallpapers
cd ~/.Wallpapers
chmod +x setup_script.sh
./setup_script.sh [/.Wallpapers]# Change argument here if custom directory location.
```  
3. To check the logs whether the cron job is updating the wallpaper daily run:  
```bash
cat ~/.Wallpapers/cron.log
```
