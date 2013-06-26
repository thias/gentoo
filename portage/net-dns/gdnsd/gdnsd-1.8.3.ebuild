# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils user

DESCRIPTION="Authoritative-only DNS server"
HOMEPAGE="https://github.com/blblack/gdnsd"
SRC_URI="http://downloads.gdnsd.net/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+libcap urcu"

DEPEND="libcap? ( sys-libs/libcap )
    dev-libs/libev
    urcu? ( dev-libs/userspace-rcu )"
RDEPEND="${DEPEND}"

pkg_setup() {
    ebegin "Creating gdnsd user and group"
    enewgroup ${PN}
    enewuser ${PN} -1 -1 -1 ${PN}
    eend $?
}

src_configure() {
    econf \
        $(use_with libcap) \
        $(use_with urcu)
}

src_install() {
    emake DESTDIR="${D}" install

    newinitd "${FILESDIR}"/gdnsd.init gdnsd

    # This is where all configuration goes, but install doesn't create it
    keepdir /etc/gdnsd /etc/gdnsd/zones

    dodoc README.md docs/gdnsd_manual.txt
}
