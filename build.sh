#!/bin/bash
if [[ -n $1 ]] && [[ $1 == clean ]]; then
  if [ -e oai_hss.tar ]; then
    rm oai_hss.tar
  fi
  if [ -e oai_spgw.tar ]; then
    rm oai_spgw.tar
  fi
  if [ -e oai_mme.tar ]; then
    rm oai_mme.tar
  fi
  if [ -e oai_mme_hss.tar ]; then
    rm oai_mme_hss.tar
  fi
else
  cd hss && tar -cvf ../oai_hss.tar * && cd -
  cd spgw && tar -cvf ../oai_spgw.tar * && cd -
  cd mme && tar -cvf ../oai_mme.tar * && cd -
  cd mme_hss && tar -cvf ../oai_mme_hss.tar * && cd -
fi
