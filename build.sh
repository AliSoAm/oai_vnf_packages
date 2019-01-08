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
else
  tar -cvf oai_hss.tar hss/*
  tar -cvf oai_spgw.tar spgw/*
  tar -cvf oai_mme.tar mme/*
fi
