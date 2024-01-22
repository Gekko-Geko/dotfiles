#!/usr/bin/env bash

if [[ $EUID -eq 0 ]]; then
	clear
	echo "This script MUST NOT be run as root."
	echo "Exiting..."
	sleep 3 && exit 1
fi

USER=$(whoami)

clear
echo "                                  _____________                                     "
echo "                           __,---'::.-  -::_ _ '-----.___      ______               "
echo "                       _,-'::_  ::-  -  -. _   ::-::_   .\--,/   :: .:'-._          "
echo "                    ,-'_ ::   _  ::_ .:   :: - _ .:   ::- _/ ::   ,-. ::. '-._      "
echo "                _,-'   ::-  ::        ::-  _ ::  -  ::     |  .: ((|))      ::'.    "
echo "        ___,---'   ::    ::    ;::   ::     :.- _ ::._  :: \ :     _____::..--'     "
echo "    ,--'  ::  ::.   ,------.  (.  ::  \  ::  ::  ,-- :. _  :\. ::  \       --._     "
echo "  ,'     ::   '   _._.:_  :.)___,-------------._(.:: ____'-._ $(._ ::)--..____; ;   "
echo " ;:::. ,--'--'''''      /  /                     \. |      \-----'--'---------'     "
echo ";  '::;              _ /.:/_,                    _\.:\_,                            "
echo "|    ;             ='-//\\--'                  ='-//\\--'                           "
echo "|   .|               ''  ''                      ''  ''                             "
echo " \::'\                                                                              "
echo "  \   \                                                                             "
echo "   $(..:).                                                                          "
echo "     $(.)--.____                                                                    "
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
	librewolf-bin \
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
sleep 1 && clear

sudo systemctl enable ly
sudo systemctl enable docker
sudo systemctl enable sshd
sudo systemctl enable rsyslog

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

		[Nn]*)
			echo "Skipping..."
			sleep 1 && clear
			;;

		*)
			echo "Invalid answer, skipping..."
			sleep 1 && clear
			;;
		esac
		;;

	[Nn]*)
		echo "Skipping..."
		sleep 1 && clear
		;;
	*)
		echo "Invalid answer, skipping..."
		sleep 1 && clear
		;;
	esac
fi

#########################
# Home setup
#########################

DIRECTRIES=".cache .config .local Desktop Downloads Doxuments Music Pictures Videos"
PROGRAMS="dunst lf tmux zsh"
for directory in $DIRECTRIES; do
	[ ! -d "$HOME/$directory" ] && mkdir "$HOME/$directory"
done

for program in $PROGRAMS; do
	DIR="$HOME/.config/$program"
	if [ ! -d "$DIR" ]; then
		mkdir "$DIR"
		cp -r "$program/*" "$DIR"
	fi
done

cp ./xinit/.xinitrc "$HOME/"
cp ./zsh/.zshenv "$HOME/"
cp ./scripts/* "/usr/bin/"
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
  MatchIsKeyboard "on"
  Option "XkbOptions" "caps:escape"
EndSection
EOF
	sleep 1 && clear
	;;
[Nn]*)
	echo "Skipping..."
	sleep 1 && clear
	;;
*)
	echo "Invalid answer, skipping..."
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
	git clone --depth 1 https://github.com/Gekko-Geko/dwm.git "$HOME"/.config/dwm
	cd "$HOME"/.config/dwm || exit
	sudo make clean install
	git clone --depth 1 https://github.com/Gekko-Geko/dmenu.git "$HOME"/.config/dmenu
	cd "$HOME"/.config/dmenu || exit
	sudo make clean install
	git clone --depth 1 https://github.com/Gekko-Geko/st.git "$HOME"/.config/st
	cd "$HOME"/.config/st || exit
	sudo make clean install
	sleep 1 && clear
	;;
[Nn]*)
	echo "Skipping..."
	sleep 1 && clear
	;;
*)
	echo "Invalid answer, skipping..."
	sleep 1 && clear
	;;
esac
