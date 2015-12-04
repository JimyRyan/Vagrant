#!/bin/bash

echo "Finish setup of oh-my-zsh for root..."
sed -i '/^cd \/vagrant$/d' ~/.zshrc > /dev/null 2>&1
echo 'cd /vagrant' >> ~/.zshrc

echo "Copy oh-my-zsh config for vagrant user..."
chsh -s $(which zsh) vagrant > /dev/null 2>&1
cp -r ~/.oh-my-zsh /home/vagrant > /dev/null 2>&1
cp ~/.zshrc /home/vagrant/.zshrc > /dev/null 2>&1
sed -i 's/^export ZSH=\/root\/.oh-my-zsh$/export ZSH=\/home\/vagrant\/.oh-my-zsh/g' /home/vagrant/.zshrc > /dev/null 2>&1
chown vagrant:vagrant -R /home/vagrant/.oh-my-zsh > /dev/null 2>&1
chown vagrant:vagrant /home/vagrant/.zshrc > /dev/null 2>&1

echo "Finish..."
apt-get autoremove -y > /dev/null 2>&1
updatedb > /dev/null 2>&1