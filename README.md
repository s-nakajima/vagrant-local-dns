# ローカル開発環境用のDNSサーバー

Vagrant で立ち上げた Web サーバに iPad(iPhone)などのスマホ からアクセスさせるための DNS サーバー


## 手順

1. スマホからアクセスさせたい Virtual Machine (VM) のネットワーク設定を public にする<br>
※IPアドレスは、各環境に応じて変更してください。

````Vagrantfile
config.vm.network :public_network, ip: '192.168.1.201'
````

2. スマホからアクセスさせたい VM を `vagrant up`<br>
==> `default: Adapter 2: bridged`があればOK

````
==> default: Clearing any previously set forwarded ports...
==> default: Clearing any previously set network interfaces...
==> default: Preparing network interfaces based on configuration...
    default: Adapter 1: nat
    default: Adapter 2: bridged
    default: Adapter 3: hostonly
==> default: Forwarding ports...
    default: 22 (guest) => 2251 (host) (adapter 1)
    default: 80 (guest) => 9051 (host) (adapter 1)
==> edumap-app: Running 'pre-boot' VM customizations...
````



3. スマホからアクセスさせたい VM の IPアドレスを確認<br>
==> 1で設定したIPアドレスが表示されればOK
````
$ vagrant ssh -c "ip addr show"
````


4. この VM の `tools/environment/hosts-dnsmasq` を 1のIPアドレスに変更<br>
https://github.com/s-nakajima/vagrant-local-dns/blob/master/tools/environment/hosts-dnsmasq

5. この VM のVagrantfileのIPアドレスを設定する<br>
※IPアドレスは、各環境に応じて変更してください。

````
node.vm.network :public_network, ip: '192.168.1.200'
````

6. この VM を `vagrant up`

7. 別の PC から dig コマンドを実行して、DNS がつながるか確認<br>
※もし、接続されないときは、別 PC からこの VM のホスト PC に接続できない可能性が高いです。<br>
　セキュリティソフトのFirewallなどを確認して下さい。

````
$ dig @192.168.1.200 sample1.local.jp

; <<>> DiG 9.9.4-RedHat-9.9.4-61.el7_5.1 <<>> @192.168.1.200 sample1.local.jp
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 56692
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
;; QUESTION SECTION:
;sample1.local.jp.       IN      A

;; ANSWER SECTION:
sample1.local.jp. 0      IN      A       192.168.1.201

;; Query time: 10 msec
;; SERVER: 192.168.1.200#53(192.168.1.200)
;; WHEN: Wed May 19 11:25:30 JST 2021
;; MSG SIZE  rcvd: 68
````

7. スマホの DNS 設定に 5のIPアドレスを追加する

