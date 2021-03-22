function chpwd
  python -c "
curdir = '$PWD' + '\n'
if curdir.startswith('$HOME'):
    curdir = curdir.replace('$HOME', '\$HOME')
if '$USER' in curdir:
    curdir = curdir.replace('$USER', '\$USER')
with open('$HIST_DIRS_FILE', 'r') as f:
    lines = f.readlines()
if len(lines) > $HIST_DIRS_MAX:
    lines = lines[-$HIST_DIRS_MAX:]
while curdir in lines:
    lines.remove(curdir)
lines.append(curdir)
with open('$HIST_DIRS_FILE', 'w') as f:
    f.write(''.join(lines))
"
end
