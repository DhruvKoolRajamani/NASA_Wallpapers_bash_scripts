# NASA_Wallpapers_bash_scripts

Bash scripts to download Nasa wallpapers everyday for gnome desktop environments.  
This project has been forked from JoshSchreuder's gist (https://gist.github.com/JoshSchreuder/882666).  

## Steps

1. Clone this repository into a hidden folder in your Home directory (my preferred choice)  
   but can be any other directory.
2. Run the [setup_script.sh](./setup_script.sh)  
```bash
mkdir ~/.Wallpapers && cd ~/.Wallpapers
git clone https://github.com/DhruvKoolRajamani/NASA_Wallpapers_bash_scripts.git NASA
cd NASA
chmod +x setup_script.sh
./setup_script.sh
```  
3. To check the logs whether the cron job is updating the wallpaper daily run:  
```bash
cat ~/.Wallpapers/NASA/cron.log
```
