#!/bin/bash

# Function to update or add variables
update_or_add_variable() {
	local key="$1"
	local value="$2"
	local file="$HOME/.zshrc" # Path to the configuration file

	if grep -q "^$key=" "$file"; then
		sed -i "s/^$key=.*/$key=$value/" "$file"
		echo "Updated $key to $value in $file."
	else
		echo "$key=$value" >> "$file"
		echo "Added $key=$value to $file."
	fi
}

check_package_installed() {
  local package_name="$1"
	if command -v "$package_name" > /dev/null 2>&1; then
		return 0  # true
	else
		return 1
	fi
}

# Function to add a plugin to the Zsh plugins list
add_zsh_plugin() {
	local plugin="$1"
	local zshrc="$HOME/.zshrc"

	# Check if plugins variable exists in .zshrc
	if grep -q "^plugins=" "$zshrc"; then
		# Check if the plugin is already in the list
		if ! grep -q "$plugin" "$zshrc"; then
			# Add the plugin to the existing plugins list
			sed -i "s/^plugins=(\(.*\))/plugins=(\1 $plugin)/" "$zshrc"
			echo "Added $plugin to the plugins list."
		else
			echo "$plugin is already in the plugins list."
		fi
	else
		# If plugins variable doesn't exist, add it with the plugin
		echo "plugins=($plugin)" >> "$zshrc"
		echo "Created plugins list and added $plugin."
	fi
}

# Function to install dependencies
update_system() {
	echo "Installing Zsh..."
	if [ -f /etc/os-release ]; then
		source /etc/os-release
		if [[ "$ID" =~ (debian|ubuntu|linuxmint) ]]; then
			sudo apt install update && sudo apt upgrade -y
		elif [[ "$ID" =~ (fedora|centos|rhel|rocky|almalinux) ]]; then
			sudo dnf update
		else
			echo "Unsupported Linux distribution: $ID"
			exit 1
		fi
	elif [[ "$(uname)" == "Darwin" ]]; then
		brew update && brew upgrade
	else
		echo "Unsupported operating system."
		exit 1
	fi
}
