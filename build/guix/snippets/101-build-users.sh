# refer: https://elephly.net/posts/2015-06-21-getting-started-with-guix.html

groupadd --system guix-builder
for i in `seq 1 10`;
do
  useradd -g guix-builder -G guix-builder           
          -d /var/empty -s `which nologin`          
          -c "Guix build user $i" --system          
          guix-builder$i;
done
  
