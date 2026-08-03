#!/bin/sh

set -eu

ARCH="$(uname -m)"
echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm dotnet-sdk libadwaita

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

echo "Building pinta..."
echo "---------------------------------------------------------------"
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export DOTNET_NOLOGO=1

git clone --depth 1 --branch 3.1.2 https://github.com/PintaProject/Pinta.git ./pinta-src && (
	cd ./pinta-src
	# The 3.1.2 release targets net8.0; match the Arch package by bumping to net10.0
	sed -i 's/net8.0/net10.0/g' Directory.Build.props

	# Mono.Addins uses reflection to (re)build its add-in database, which the
	# trimmer strips -> root the addin/cecil assemblies so they stay intact
	cat > Directory.Build.targets <<-'EOF'
	<Project>
	<ItemGroup>
	<TrimmerRootAssembly Include="Mono.Addins" />
	<TrimmerRootAssembly Include="Mono.Addins.Setup" />
	<TrimmerRootAssembly Include="Mono.Addins.CecilReflector" />
	<TrimmerRootAssembly Include="Mono.Cecil" />
	<TrimmerRootAssembly Include="Mono.Cecil.Rocks" />
	<TrimmerRootAssembly Include="Mono.Cecil.Mdb" />
	<TrimmerRootAssembly Include="Mono.Cecil.Pdb" />
	</ItemGroup>
	</Project>
	EOF

	dotnet publish ./Pinta/Pinta.csproj \
		-c Release                  \
		-r linux-x64                \
		--self-contained true       \
		-p:PublishTrimmed=true      \
		-p:TrimMode=partial         \
		-p:BuildTranslations=true   \
		-p:PublishDir=/usr/lib/pinta

	# Dead weight, nothing references these
	rm -f \
		/usr/lib/pinta/Microsoft.CodeAnalysis.dll        \
		/usr/lib/pinta/Microsoft.CodeAnalysis.CSharp.dll \
		/usr/lib/pinta/Mono.Cecil.Mdb.dll                \
		/usr/lib/pinta/Mono.Cecil.Pdb.dll                \
		/usr/lib/pinta/Mono.Cecil.Rocks.dll

	# dlopen'd lazily only when tracing, would drag in liblttng-ust
	rm -f /usr/lib/pinta/libcoreclrtraceptprovider.so

	cp -r /usr/lib/pinta/icons/hicolor /usr/share/icons
	sed 's/^_//' ./xdg/com.github.PintaProject.Pinta.desktop.in > /usr/share/applications/Pinta.desktop
	cp -r /usr/lib/pinta/locale/. /usr/share/locale

	awk -F'<|>' '/<Version>/{print $3; exit}' ./Directory.Build.props | sed 's/\.0$//' > ~/version
)

echo "Building libappstream stub..."
echo "---------------------------------------------------------------"
cc -shared -fPIC -O2 -o ./libappstream.so.5 -Wl,-soname,libappstream.so.5 libappstream-stub.c
mv -v ./libappstream.so.5 /usr/lib
