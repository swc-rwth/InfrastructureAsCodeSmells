echo "JUL000 $(grep -c JUL000 $1)"
echo "JUL001 $(grep -c JUL001 $1)"
echo "JUL010 $(grep -c JUL010 $1)"
echo "JUL011 $(grep -c JUL011 $1)"
echo "JUL012 $(grep -c JUL012 $1)"
echo "JUL020 $(grep -c JUL020 $1)"
echo "JUL030 $(grep -c JUL030 $1)"
echo "JUL040 $(grep -c JUL040 $1)"
echo "JUL050 $(grep -c JUL050 $1)"
echo "JUL051 $(grep -c JUL051 $1)"
echo "JUL061 $(grep -c JUL061 $1)"
echo "JUL070 $(grep -c JUL070 $1)"
echo "JUL080 $(grep -c JUL080 $1)"
echo "JUL090 $(grep -c JUL090 $1)"
echo "JUL091 $(grep -c JUL091 $1)"
echo "JUL092 $(grep -c JUL092 $1)"
echo "JUL093 $(grep -c JUL093 $1)"
echo "JUL094 $(grep -c JUL094 $1)"
echo "JUL100 $(grep -c JUL100 $1)"
echo "JUL111 $(grep -c JUL111 $1)"
echo "JUL120 $(grep -c JUL120 $1)"
echo "JUL130 $(grep -c JUL130 $1)"
echo "JUL140 $(grep -c JUL140 $1)"
echo "JUL150 $(grep -c JUL150 $1)"
echo "JUL160 $(grep -c JUL160 $1)"

echo $(($(grep -c JUL000 $1) + $(grep -c JUL001 $1) + $(grep -c JUL010 $1) + $(grep -c JUL011 $1) + $(grep -c JUL012 $1) + $(grep -c JUL020 $1) +  + $(grep -c JUL030 $1) + $(grep -c JUL040 $1) + $(grep -c JUL050 $1) + $(grep -c JUL051 $1) + $(grep -c JUL061 $1) + $(grep -c JUL070 $1) + $(grep -c JUL080 $1) + $(grep -c JUL090 $1) + $(grep -c JUL091 $1) + $(grep -c JUL092 $1) + $(grep -c JUL093 $1) + $(grep -c JUL094 $1) + $(grep -c JUL100 $1) + $(grep -c JUL111 $1) + $(grep -c JUL120 $1) + $(grep -c JUL130 $1) + $(grep -c JUL140 $1) + $(grep -c JUL150 $1) + $(grep -c JUL160 $1)))
