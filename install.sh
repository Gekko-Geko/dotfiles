#!/usr/bin/env bash

if [[ $EUID -eq 0 ]]; then
	clear
	echo "This script MUST NOT be run as root."
	echo "Exiting..."
	sleep 3 && exit 1
fi

USER=$(whoami)
PATH=$(pwd)

clear
echo "                                  _____________                                     "
echo "                           __,---'::.-  -::_ _ '-----.___      ______               "
echo "                       _,-'::_  ::-  -  -. _   ::-::_   .\--,/   :: .:'-._          "
echo "                    ,-'_ ::   _  ::_ .:   :: - _ .:   ::- _/ ::   ,-. ::. '-._      "
echo "                _,-'   ::-  ::        ::-  _ ::  -  ::     |  .: ((|))      ::'.    "
echo "        ___,---'   ::    ::    ;::   ::     :.- _ ::._  :: \ :     _____::..--'     "
echo "    ,--'  ::  ::.   ,------.  (.  ::  \  ::  ::  ,-- :. _  :\. ::  \       --._     "
echo "  ,'     ::   '   _._.:_  :.)___,-------------._(.:: ____'-._  (._ ::)--..____; ;   "
echo " ;:::. ,--'--'''''      /  /                     \. |      \-----'--'---------'     "
echo ";  '::;              _ /.:/_,                    _\.:\_,                            "
echo "|    ;             ='-//\\--'                  ='-//\\--'                           "
echo "|   .|               ''  ''                      ''  ''                             "
echo " \::'\                                                                              "
echo "  \   \                                                                             "
echo "   \..:).                                                                           "
echo "     \(.)--.____                                                                    "
echo "       '-:______ '-._                                                               "
echo "                '---'                                                               "
echo "                                                                                    "
echo "https://github.com/Gekko-Geko"
echo ""

#########################
# Install programs
#########################

echo "Installing programs..."
sleep 1 && clear

echo "Installing paru..."
git clone https://aur.archlinux.org/paru.git /tmp/paru
cd /tmp/paru || exit
makepkg -si
cd "$(PATH)" || exit
sleep 1 && clear

echo "Installing programs..."
paru -S base \
	base-devel \
	blueman \
	bluez-tools \
	bluez-utils \
	btop \
	checkupdates-with-aur \
	cups \
	dbus \
	discord \
	dnscrypt-proxy \
	docker \
	docker-compose \
	dos2unix \
	dunst \
	exa \
	ffmpeg \
	ffmpegthumbnailer \
	firefox \
	fzf \
	gd \
	git \
	gnu-free-fonts \
	lazygit \
	lf \
	libnotify \
	libx11 \
	libxft \
	libxinerama \
	linux-headers \
	ly \
	maim \
	make \
	man-db \
	man-pages \
	mpv \
	ncdu \
	neofetch \
	neovim \
	networkmanager \
	noto-fonts \
	noto-fonts-cjk \
	noto-fonts-emoji \
	openssh \
	openvpn \
	pcmanfm \
	picom \
	pulseaudio \
	pulsemixer \
	python-pip \
	ripgrep \
	rsyslog \
	runelite \
	skippy-xd-git \
	sxiv \
	syncthing \
	tmux \
	tree \
	ttf-font-awesome \
	ttf-hack \
	ttf-hack-nerd \
	ttf-jetbrains-mono-nerd \
	udiskie \
	ueberzugpp \
	unzip \
	vim \
	wget \
	xorg-server \
	xorg-xinit \
	zathura \
	zathura-pdf-mupdf \
	zip \
	zsh \
	--noconfirm

sudo systemctl enable ly
sudo systemctl enable docker
sudo systemctl enable sshd
sudo systemctl enable rsyslog

sleep 1 && clear

#########################
# Laptop setup
#########################

if [ -d "/sys/class/power_supply" ] && [ "$(ls -A /sys/class/power_supply)" ]; then
	echo "Is this installation on a laptop? (y/n)"
	read -r answer
	sleep 1 && clear

	case $answer in
	[Yy]*)
		echo "Installing dependencies..."
		paru -S acpi acpilight
		sudo chown "$USER" /sys/class/backlight/intel_backlight/brightness
		sleep 1 && clear
		echo "Want to enable touchpad tap-to-click? (y/n)"
		read -r answer
		sleep 1 && clear

		case $answer in
		[Yy]*)
			echo "Enabling tap-to-click..."
			sudo mkdir -p /etc/X11/xorg.conf.d && sudo tee /etc/X11/xorg.conf.d/90-touchpad.conf <<'EOF' 1>/dev/null
Section "InputClass"
  Identifier "touchpad"
  MatchIsTouchpad "on"
  Driver "libinput"
  Option "Tapping" "on"
EndSection
EOF
			sleep 1 && clear
			;;

		*)
			echo "Skipping..."
			sleep 1 && clear
			;;
		esac
		;;

	*)
		echo "Skipping..."
		sleep 1 && clear
		;;
	esac
fi

#########################
# Home setup
#########################

DIRECTORIES=".cache .config .local Desktop Downloads Doxuments Music Pictures Videos"
for directory in $DIRECTORIES; do
	[ ! -d "$HOME/$directory" ] && mkdir "$HOME/$directory"
done

PROGRAMS="dunst lf tmux zsh"
for program in $PROGRAMS; do
	DIR="$HOME/.config/$program"
	if [ ! -d "$DIR" ]; then
		cp -r "$(pwd)/$program" "$HOME/.config"
	fi
done

cp ./xinit/.xinitrc "$HOME/"
cp ./zsh/.zshenv "$HOME/"
sudo cp ./scripts/* "/usr/bin/"
cp -r ./.cache/wal "$HOME/.cache/"
git clone --depth 1 https://github.com/LazyVim/starter "$HOME/.config/nvim"
rm -rf "$HOME/.config/nvim/.git"

echo "Switch capslock and escape keys? (y/n)"
read -r answer
sleep 1 && clear

case $answer in
[Yy]*)
	sudo mkdir -p /etc/X11/xorg.conf.d && sudo tee /etc/X11/xorg.conf.d/91-keyboard.conf <<'EOF' 1>/dev/null
Section "InputClass"
  Identifier "system-keyboard"
  MatchIsKeyboard "on"
  Option "XkbOptions" "caps:escape"
EndSection
EOF
	sleep 1 && clear
	;;
*)
	echo "Skipping..."
	sleep 1 && clear
	;;
esac

echo "Change default shell for $USER to zsh"
sudo chsh --shell /bin/zsh "$USER"
sleep 1 && clear

#########################
# Suckless setup
#########################

echo "Download and Install suckless programs? (y/n)"
read -r answer
sleep 1 && clear

case $answer in
[Yy]*)
	SUCKLESS="dwm dmenu st dwmblocks"
	for suck in $SUCKLESS; do
		git clone --depth 1 "https://github.com/Gekko-Geko/$suck.git" "$HOME/.config/$suck"
		cd "$HOME/.config/$suck" || exit
		sudo make clean install
	done
	sleep 1 && clear
	;;
*)
	echo "Skipping..."
	sleep 1 && clear
	;;
esac
